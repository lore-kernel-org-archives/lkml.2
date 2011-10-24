Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1JXMug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:50:36 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:29001 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932399Ab1JXMub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:50:31 -0400
Message-ID: <4EA55F0B.1070906@enea.com>
Date: Mon, 24 Oct 2011 14:50:19 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Memory leak in isp1760-hcd.c
References: <20111019152132.GH29653@arm.com>
In-Reply-To: <20111019152132.GH29653@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.1.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, and sorry for the late reply.

Catalin Marinas wrote:
> Hi Arvid,
> 
> I get the following kmemleak report coming from the ISP1760 driver:
> 
*snip*
> 
> Is there a race condition between isp1760_endpoint_disable and
> isp1760_irq?
 
Yes, I think there is. Thanks for a great bug report!

Please try the patches in following emails.

-- 
Arvid Brodin
Enea Services Stockholm AB

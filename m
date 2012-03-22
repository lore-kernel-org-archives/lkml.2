Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab2CVOO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:14:29 -0400
Received: from metasoft.pl ([195.149.224.191]:49624 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2CVOO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:14:28 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F6B3399.2010501@metasoft.pl>
Date: Thu, 22 Mar 2012 15:13:45 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Ryan Mallon <rmallon@gmail.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <4F6A78ED.3050403@gmail.com> <4F6AF845.9070209@metasoft.pl> <4F6B25A4.4090006@mvista.com>
In-Reply-To: <4F6B25A4.4090006@mvista.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-22 14:14, Sergei Shtylyov wrote:
>    IDE or libata driver? Asking because IDE drivers are not accepted anymore.

Libata. Basically, it's the driver posted by Bartlomiej Zolnierkiewicz with
some changes (the most important being UDMA support).

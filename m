Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1IVXQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:16:06 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:15889
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370Ab1IVXQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:16:00 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E7BC1A9.5050708@freescale.com>
Date: Thu, 22 Sep 2011 18:15:53 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH] drivers/tty: don't use the byte channel handle as a parameter
 in ehv_bytechan.c
References: <1316543217-13769-1-git-send-email-timur@freescale.com> <20110922230640.GA16981@kroah.com>
In-Reply-To: <20110922230640.GA16981@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> This patch doesn't apply at all to my tty tree, what was it made
> against?

An internal repository that supposed to be in-sync with the latest and greatest.

What's the URL for your tty-next repo?

-- 
Timur Tabi
Linux kernel developer at Freescale


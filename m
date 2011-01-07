Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1AGRF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:05:26 -0500
Received: from xenotime.net ([72.52.115.56]:52878 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754394Ab1AGRFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:05:24 -0500
Date: Fri, 7 Jan 2011 09:05:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Weber <weber@corscience.de>, Johannes Reif <reif@corscience.de>,
        changgx <changgx@163.com>, miguelangel@nbee.es
Subject: Re: [PATCH resend 2] Add sc16is7x2 driver
Message-Id: <20110107090519.dc31d72b.rdunlap@xenotime.net>
In-Reply-To: <4D272DDA.6010007@iis.fraunhofer.de>
References: <4D272DDA.6010007@iis.fraunhofer.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jan 2011 16:14:34 +0100 Manuel Stahl wrote:

> IRQ is now implemented with work queue (like max3100).
> The problem is, that the sc16is7x2 has a low active irq. But with active 
> low threaded_irqs, shared irqs are not allowed.
> 
> Please try this one and report errors.
> 
> Regards,
> Manuel Stahl
> 
> PS: sorry that the patch is not inline, not sure how to configure 
> thunderbird correctly

Please check to see if Documentation/email-clients.txt can help you,
although it may be a bit outdated.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

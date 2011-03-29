Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1C2OJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:09:27 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:38881 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1C2OJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:09:26 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
References: <20110325142344.058372664@linutronix.de>
In-Reply-To: <20110325142344.058372664@linutronix.de>
Subject: RE: [patch 0/2] unicore32: Final irq bits for .39
Date: Tue, 29 Mar 2011 22:09:08 +0800
Message-ID: <019401cbee1a$e02d0bc0$a0872340$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEqwHQoTzbgKMZbeAtd7l1GSN8fHZWGtCwA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, March 25, 2011 10:27 PM
> To: LKML
> Cc: Guan Xuetao
> Subject: [patch 0/2] unicore32: Final irq bits for .39
> 
> Guan,
> 
> the following series converts unicore to the new irq function names
> and makes use of the generic show_interrupts() implementation.
> 
> Can you please ack or send it to Linus yourself?
> 
> Thanks,
> 
> 	tglx

Looks good to me.
I have applied these patches in my branch.

Thanks & Regards.

Guan Xuetao


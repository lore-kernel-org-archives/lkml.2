Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0KDSFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:05:22 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:38704 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751282Ab0KDSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:05:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: MfHLYq4VM1kAYRpIuoyLpGE3Fx6f9Y_tSVWXHCX7RXm6cio
 TV7wW9xF3BzrJFUFCIjvSuMG0Leca7DAsbL_m46TfswKA3YAUuDjBtAdWVZB
 9rrll5cBwTOBcXRmL2TK.RvQtOv_0INKg6IsaZPX6A8U5SECT6LrONUqEW1G
 lXBQQphnI8nW0IZMGCevaaGPATUqywLSF1PLw3VdV8CFCWckkxzE3ye7mg._
 vZ740DyIVKRVNm6oWfCDJECZ_wDVknkgmF9QStyJd25f30zorRZKaXPu3jwd
 II8PJPrJe
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 4 Nov 2010 13:05:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irq: use per_cpu kstat_irqs
In-Reply-To: <1288892908.2659.175.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011041257140.8431@router.home>
References: <1288892908.2659.175.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Nov 2010, Eric Dumazet wrote:

>  static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
>  {
> -       return kstat_cpu(cpu).irqs[irq];
> +	return kstat_cpu(cpu).irqs[irq];
>  }

Whitespace fixes?

Looks ok otherwise.

Reviewed-by: Christoph Lameter <cl@linux.com>

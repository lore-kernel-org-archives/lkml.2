Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1FAGll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:41:41 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49808 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab1FAGlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:41:40 -0400
Subject: Re: x86: tsc: Remove unneeded DMI-based blacklisting
From: john stultz <johnstul@us.ibm.com>
To: Tero Roponen <tero.roponen@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.02.1105311020590.7332@terrop>
References: <alpine.LFD.2.02.1105311020590.7332@terrop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 23:41:35 -0700
Message-ID: <1306910495.3359.52.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 10:24 +0300, Tero Roponen wrote:
> The blacklist was added in response to my bug report
> (http://lkml.org/lkml/2006/1/19/362) and has never
> contained more than the one entry describing my old
> now dead ThinkPad 380XD laptop. As found out later
> (http://lkml.org/lkml/2007/11/29/50), this special
> treatment has been unnecessary for a long time, so
> it can be removed.
> 
> Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

Wow. Those are old mails! Thanks for following up here to clarify that
these bits aren't needed. 

I'll apply and queue this for 3.1.

thanks
-john



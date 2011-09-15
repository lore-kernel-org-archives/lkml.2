Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1IOHn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:43:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63096 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1IOHn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:43:57 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4E6FA8AE.5010308@xenotime.net>
References: <1315465029-4203-1-git-send-email-gilad@benyossef.com>
	<4E6FA8AE.5010308@xenotime.net>
Date: Thu, 15 Sep 2011 10:43:56 +0300
Message-ID: <CAOtvUMcud5jZnj7XVp1FhbDf=wr_rTKgAV8EOo6g+RO=y7A5mQ@mail.gmail.com>
Subject: Re: [PATCH Resend][Trivial] Match on_each_cpu behaviour on UP to SMP
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 13, 2011, Randy Dunlap wrote:

> > +             local_irq_retore(__flags);      \
>
> You tested that?          ^^^^^^

Ouch... that was very very silly of me.  Sorry for the time wasted.

I've just send a fixed patch which I built and booted on a UP x86 machine.

Thanks,
Gilad

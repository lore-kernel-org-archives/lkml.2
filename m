Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1I0Hfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:35:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48991 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1I0Hfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <1317107502.2327.4.camel@phoenix>
References: <1317107502.2327.4.camel@phoenix>
Date: Tue, 27 Sep 2011 09:35:46 +0200
Message-ID: <CACRpkdbhqq3Y85pf+i=ssP2MKVW_ROL5QpFvAy0ffHMbshrSQA@mail.gmail.com>
Subject: Re: [RFC][PATCH] cpufreq: db8500: remove unneeded for loop iteration
 over freq_table
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, cpufreq@vger.kernel.org,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 9:11 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Don't know why to do the loop iteration here. It looks unneeded.

I'm OK with this going in, however I already have another patch
on the CPUfreq driver pending for review that is more crucial and
hopefully can go in first?

It sure looks odd. Jonas has some refactorings done on the
CPUfreq driver, however they are dependent on the PRCMU update
that is pending review for the MFD tree to go in first, so there
is some code stacking up cross-subsystemwise right now.

Yours,
Linus Walleij

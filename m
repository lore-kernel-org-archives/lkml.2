Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab2KBAkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:40:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60222 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2KBAka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:40:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211012358280.2756@ionos>
References: <20121031003258.811955127@goodmis.org>
	<20121031003314.763160265@goodmis.org>
	<CAN8Q1EcVfzJJh+XMeXMMk33kwyyyRoEWsuEbSQqVW0Vz3i3Vuw@mail.gmail.com>
	<alpine.LFD.2.02.1211012213460.2756@ionos>
	<CAN8Q1Ecq9T5HC60_ta8Xr9kKyAe8Fjrd8znV9MpDTYqkSSptOw@mail.gmail.com>
	<alpine.LFD.2.02.1211012358280.2756@ionos>
Date: Thu, 1 Nov 2012 17:40:28 -0700
X-Google-Sender-Auth: Sc791NoEsQDs4BTdaIO_hfEtzDQ
Message-ID: <CAN8Q1EcKiBG_S5NuKpw3viHFM7kW5WYuzvpVvL+Pnj1dekWUug@mail.gmail.com>
Subject: Re: [PATCH RT 3/4] net: netfilter: Serialize xt_write_recseq sections
 on RT
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> git log v3.0.36-rt58..3.0.48-rt72
>
> That's what a source version control system is designed for AFAICT

Thanks for the tip.  I (naively) presumed there were published
changelogs and was looking for them.  Nor did I know the git logs were
limited to releases, and didn't look there because I feared a huge
number of mid-release commits.  Thanks for the pointer.

I've gone through all the commits from 3.0.36-rt58 to 3.0.48-rt72 and
see a few items we need to pull in.  The majority are irrelevant to
our platform/configuration (ALSA, SCSI, x86, etc).  But the few I did
find point to us moving to rt72 when we can.

Thanks,
Pete

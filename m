Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445Ab2KAWap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:30:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53252 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761979Ab2KAWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211012213460.2756@ionos>
References: <20121031003258.811955127@goodmis.org>
	<20121031003314.763160265@goodmis.org>
	<CAN8Q1EcVfzJJh+XMeXMMk33kwyyyRoEWsuEbSQqVW0Vz3i3Vuw@mail.gmail.com>
	<alpine.LFD.2.02.1211012213460.2756@ionos>
Date: Thu, 1 Nov 2012 15:30:42 -0700
X-Google-Sender-Auth: Lm5XcJSQU3czRP6oW9WaZqIARKs
Message-ID: <CAN8Q1Ecq9T5HC60_ta8Xr9kKyAe8Fjrd8znV9MpDTYqkSSptOw@mail.gmail.com>
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

On Thu, Nov 1, 2012 at 2:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Cough. You are missing a boat load of crucial fixes. There is a damned
> good reason why 3.0.stable got 12 updates and the -rt version 14.

I don't doubt there are.  But we've only experienced one problem
between 3.0.36-rt58 and 3.0.48-rt72.  Indeed, it might be easier to
evaluate the risk if all the changelogs were readily available.  So
far, however, we haven't discovered any other issues that give us any
concerns.

> Your risk assessment is definitley interesting.

We have specifically tested 3.0.36-rt58 for performance in our
application.  Moving to 3.0.48-rt72 poses risk about whether would
still be able to meet our performance requirements.  And with regard
to stability, the only issue we've had since our earlier moved to
3.0.36-rt58 was the netfilter problem.  We initially only saw the
problem on PPP related interfaces, so we reverted to 3.0.3 (non-rt)
for PPP related issues.

Now, if you think there are some issues that should raise eyebrows, or
can point me to a list of changelogs, I'd be happy to evaluate them.

Thanks,
Pete

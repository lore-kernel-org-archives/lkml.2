Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2KBWZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:25:48 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53042 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2KBWZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAN8Q1EcHJyDMs-z8Vw_=cpnCL2FO_pATaGThh2UHv4ketC-_Jw@mail.gmail.com>
References: <20121031003258.811955127@goodmis.org>
	<20121031003314.763160265@goodmis.org>
	<CAN8Q1EcHJyDMs-z8Vw_=cpnCL2FO_pATaGThh2UHv4ketC-_Jw@mail.gmail.com>
Date: Fri, 2 Nov 2012 15:25:45 -0700
X-Google-Sender-Auth: G6pqKH5siBOMWmYfXtWV9Judm_w
Message-ID: <CAN8Q1EfDQi0Lh3215rA9aqzNcn1F5K7OqCLxZYmQ4WgXZyDDUw@mail.gmail.com>
Subject: Re: [PATCH RT 3/4] net: netfilter: Serialize xt_write_recseq sections
 on RT
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 5:36 PM, Peter LaDow <petela@gocougs.wsu.edu> wrote:
> I'm have a setup running 3.0.48-rt72.  It's been running about 8 hours
> so far, and tomorrow I'll know if there's been any problems.  I'm
> confident things will be fine tomorrow, and at that time I'll be glad
> to attach a Tested-by tag.

Ok.  We've had 3.0.48-rt72 running on our setup that used to exhibit
the corruption of the sequence count xt_recseq for over 24 hours.  No
further corruptions occurred.  We've also tested this same version
with our PPP setup and it has not exhibited any problems.  Feel free
to add a Tested-by tag on the 3.0.48-rt72 patch for the netfilter
code.

Thanks,
Pete

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2KBW2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:28:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2KBW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAN8Q1EfDQi0Lh3215rA9aqzNcn1F5K7OqCLxZYmQ4WgXZyDDUw@mail.gmail.com>
References: <20121031003258.811955127@goodmis.org>
	<20121031003314.763160265@goodmis.org>
	<CAN8Q1EcHJyDMs-z8Vw_=cpnCL2FO_pATaGThh2UHv4ketC-_Jw@mail.gmail.com>
	<CAN8Q1EfDQi0Lh3215rA9aqzNcn1F5K7OqCLxZYmQ4WgXZyDDUw@mail.gmail.com>
Date: Fri, 2 Nov 2012 15:28:05 -0700
X-Google-Sender-Auth: XvFIylg58YDWv2b6HpZG5Jq_Ly0
Message-ID: <CAN8Q1EfD4LeMiz1UFVzbXafi=ewKLg2myEmXt0L1nLy9VFvRsA@mail.gmail.com>
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

On a separate note, I want to thank everyone that helped with this
issue, especially Eric and Thomas, to and Steven and Thomas for
schooling me on the changelog extraction.  This problem was a big one
for us that we were struggling to understand.  All the help is greatly
appreciated.

Thanks,
Pete

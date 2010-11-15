Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab0KOXui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:50:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055Ab0KOXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <1289864780.14719.172.camel@maggy.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost> <1289864780.14719.172.camel@maggy.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 15:50:09 -0800
Message-ID: <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Valdis.Kletnieks@vt.edu, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 3:46 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2010-11-15 at 17:41 -0500, Valdis.Kletnieks@vt.edu wrote:
>
>> > +extern void sched_autogroup_detatch(struct task_struct *p);
>>
>> sched_autogroup_detach() instead?
>
> Hm, why?

You really aren't a good speller of that word, are you?

      Linus

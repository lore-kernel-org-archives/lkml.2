Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0KDCoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:44:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34488 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0KDCoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=T5b6Wh0vAOtbRahuJG/T6cMKGvHKSCEOFAbPNHr0h0YubncC+BNogCi0A1FK1KGRGA
         54j6jEzPUJkeX+SXrKpek5Lli9BTJknR2wT2nTwEvPcJCAS4IaAfgX57QXuA+9t58PlL
         6ktjLIK1h3Q93qo+wWlYHHUf6HQTvUlk6k64M=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
In-Reply-To: <AANLkTimDPdDHAg0Odp0WchOLKh3OUSOWX7_0ps8eizFk@mail.gmail.com>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com> <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com> <87oca7evbo.fsf@gmail.com> <AANLkTimDPdDHAg0Odp0WchOLKh3OUSOWX7_0ps8eizFk@mail.gmail.com>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Nov 2010 22:44:11 -0400
Message-ID: <87eib1byf8.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010 23:34:27 +0900, Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com> wrote:
> Hmm, then, can't we add a sysctl template config/script for generic
> sysctl values ?
>
That is one idea. Unfortunately, then we have something of a dependency
on out of tree userspace utilities.

> Adding this kind of CONFIG one by one seems not very helpful...
> 
This was definitely a concern of mine as well. In principle, a
distribution might want to tune any of the knobs in /proc/sys, so I
agree that adding them to Kconfig is a bit of a poor path to go down.
That being said, swappiness is an especially important tunable.

- Ben

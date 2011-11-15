Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1KOTWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:22:01 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:38203 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab1KOTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:22:00 -0500
Subject: Re: How to remove 2000+ lines from 400+ defconfig files?
From: Paul Bolle <pebolle@tiscali.nl>
To: Dave Jones <davej@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111115185728.GA16643@redhat.com>
References: <1321362602.20271.192.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz>
	 <1321371462.20271.201.camel@x61.thuisdomein> <4EC2B1F7.6090108@suse.cz>
	 <20111115185728.GA16643@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 20:21:29 +0100
Message-ID: <1321384889.20271.217.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 13:57 -0500, Dave Jones wrote:
> It seems to me that these files have always been very neglected.

Almost all of them (ie, 426 of 437) had one or more outdated macros (ie,
mentioned a macro that I could not link to a current Kconfig symbol).

With some, or perhaps a lot of, effort we might learn how long they've
been neglected. For that we need to know when every one of those 161
Kconfig symbols got dropped and see what the oldest Kconfig symbol
(turned into a macro) is in each of those 426 Kconfig files. But I'm not
sure if that actually would tell us much. I guess it's easier to just
conclude that, yes, they are rather neglected.


Paul Bolle


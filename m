Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3ACHMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:12:21 -0500
Received: from stringer.orebokech.com ([88.190.240.207]:37489 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3ACHMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:12:19 -0500
From: Romain Francoise <romain@orebokech.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fairly reproduceable crash in 3.7.1 Null pointer rb_erase+0xc4/0x292
Organization: orebokech dot com
References: <20130102222757.GC8631@merlins.org>
Date: Thu, 03 Jan 2013 08:12:18 +0100
In-Reply-To: <20130102222757.GC8631@merlins.org> (Marc MERLIN's message of
	"Wed, 2 Jan 2013 14:27:57 -0800")
Message-ID: <87sj6izqnh.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc MERLIN <marc@merlins.org> writes:

> I had pretty repeated crashes when plugging power back into my running
> laptop, but the display just freezes and I can't get a dump.

> For the crash here, I did: suspend to RAM, plug power back in, wake up.
> Laptop crashed about 3 seconds after wakeup.

Sounds like https://bugzilla.kernel.org/show_bug.cgi?id=51661 which is
fixed by 3935e89505a1c3ab3f3b0c7ef0eae54124f48905 ("watchdog: Fix
disable/enable regression"), expect that in 3.7.2...

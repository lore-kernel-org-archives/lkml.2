Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1EDIEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:04:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37276 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751275Ab1EDIEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:04:39 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18PZ1Mkg+gPkwULEWoloIdpE0O2npNmLPUSK+5/Ym
	U57VnN04n9i3kh
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc6
References: <BANLkTin=0VvkzVCswMYXcHE2gH78V7V5Lw@mail.gmail.com>
Date: Wed, 04 May 2011 10:04:34 +0200
In-Reply-To: <BANLkTin=0VvkzVCswMYXcHE2gH78V7V5Lw@mail.gmail.com> (Linus
	Torvalds's message of "Tue, 3 May 2011 20:13:30 -0700")
Message-ID: <87wri6x565.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

it seems you pushed the tag but not the branch which is still at
commit 609cfda586.

Those who are eager to try out 2.6.39-rc6 need to do

$ git fetch -t
$ git reset --hard v2.6.39-rc6

Regards,
        Sven

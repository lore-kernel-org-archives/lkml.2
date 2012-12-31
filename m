Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2LaS6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 13:58:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2LaS6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 13:58:41 -0500
To: Jovi Zhang <bookjovi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
References: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 31 Dec 2012 13:58:39 -0500
In-Reply-To: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com> (Jovi Zhang's message of "Mon, 31 Dec 2012 11:32:39 +0800")
Message-ID: <y0mliceujz4.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bookjovi wrote:


> [...]  This mail is RFC for discuss on a new dynamic tracing tool, I
> name it ktap. (only experimental project now)

Welcome to the problem domain!


> [...]
> what ktap differentiates with Systemtap is:
> [...]
> 2). ktap have good portability, because it compile source file to
> bytecode, like python and Java.

(From this PoV, systemtap is just as portable as the kernel, as it
generates the same sort of C code the kernel is built from.)

> [...]
> 5). ktap will be open source completely, with GPL license, it might be
> merge into mainline in someday, that's very convince for tracing user.

(systemtap has always been GPLv2, ever since its beginning in 2005.)


> [...]
> ktap use lua language syntax and bytecode as initial implementation,

Interesting approach.  I recall we considered it way back when, but
rejected it for a couple of reasons, including the at-the-time
perceived unwelcomeness of a serious bytecode interpreter within the
kernel.


> it could support kprobe, uprobe, userspace probe, etc.

Great.

> I wish you can give me some technical architecture pre-review for
> ktap, before ktap release 1.0.
> Any comments is welcome, thanks very much.

Have you made any source code available yet?


- FChE

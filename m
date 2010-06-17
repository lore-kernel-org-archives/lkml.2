Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab0FQWbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:31:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38667 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753123Ab0FQWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:31:23 -0400
Date: Thu, 17 Jun 2010 23:34:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617233406.1de4e132@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617222504.GD24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
	<20100617000120.13071be8@lxorguk.ukuu.org.uk>
	<20100616232230.GP24749@outflux.net>
	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
	<20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
	<20100617140630.c6ced27a.rdunlap@xenotime.net>
	<20100617211616.GA24749@outflux.net>
	<20100617231859.04fcdbde@lxorguk.ukuu.org.uk>
	<20100617222504.GD24749@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't mind putting them in commoncap at all.  I would just like people
> to agree on what they disagree about.  :)

I don't believe they belong in commoncap, but as something which can sit
on top of commoncap and then be dropped into by the security modules that
makes total sense.

(Really thats just the stacking debate and how to dodge it ;))

Ie you'd have

optionally:
		LSMs
optionally:
		cap_switches
required:
		commoncap

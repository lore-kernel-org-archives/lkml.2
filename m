Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab1FBJad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:30:33 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35476 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1FBJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:30:31 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
References: <1306999045.29297.55.camel@pasglop>
	<1307003821.29297.77.camel@pasglop>
X-Yow: Hello.  Just walk along and try NOT to think about your
 INTESTINES being almost FORTY YARDS LONG!!
Date: Thu, 02 Jun 2011 11:30:27 +0200
In-Reply-To: <1307003821.29297.77.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 02 Jun 2011 18:37:01 +1000")
Message-ID: <m2pqmwpolo.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> It looks like the patch is causing some major malfunctions of the X
> server for me, possibly related to PTYs. For example, cat'ing a large
> file in a gnome terminal hangs the kernel for -minutes- in a loop of
> what looks like flush_to_ldisc/workqueue code, (some ftrace data in the
> quoted bits further down). 

Btw., do you already have d72bce0 ("rcu: Cure load woes")?  Although
that is about an independent bug, it appears to amplify this issue a
lot.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

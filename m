Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1CAS3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:29:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459Ab1CAS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:29:45 -0500
MIME-Version: 1.0
In-Reply-To: <20110301175026.GA18770@us.ibm.com>
References: <20110301175026.GA18770@us.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Mar 2011 10:29:23 -0800
Message-ID: <AANLkTikwSXN8VgDaoUqfHcxoTNxW9uA4D2fUtRLuLbHo@mail.gmail.com>
Subject: Re: matroxfb: remove incorrect Matrox G200eV support
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 9:50 AM, Gary Hade <garyhade@us.ibm.com> wrote:
>
> Remove incorrect Matrox G200eV support that was previously added
> by commit e3a1938805d2e81b27d3d348788644f3bad004f2

That commit goes back to 2.6.28 (and is dated Oct 2008).

That means that you really need to describe the problem more:

> One serious issue with the G200eV support that I have reproduced
> on a Matrox G200eV equipped IBM x3650 M2 is the lack of text (login
> banner, login prompt, etc) on the console when X not running and
> lack of text on all of the virtual consoles after X is started.

.. but without the commit, you get no fb at all, right? So even with
the commit, at worst you'd just be able to not use the matroxfb
driver, right?

What I'm trying to say is that I suspect there are G200eV users that
likely prefer having the support in - even though it's not perfect.
And the fact that the commit has been there for 2.5 years without
comments makes me very loath to just revert it.

                           Linus

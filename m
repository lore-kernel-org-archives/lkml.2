Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab0JRPcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:32:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43899 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab0JRPcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:32:54 -0400
Date: Mon, 18 Oct 2010 17:32:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] vmlinux.lds.h: gather .data..shared_aligned sections
	in DATA_DATA
Message-ID: <20101018153251.GA9939@merkur.ravnborg.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com> <1287383251-28427-1-git-send-email-vapier@gentoo.org> <AANLkTin5e8mORKCgq1ArkLiTfYkrrPAGaO07rYpwO73s@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5e8mORKCgq1ArkLiTfYkrrPAGaO07rYpwO73s@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 02:30:37AM -0400, Mike Frysinger wrote:
> Sam: i'm not trying to steal credit here ... if you want me to resend
> with you as author + sob, lemme know.  i'd just like this issue fixed
> already since 2.6.35 shipped with this broken setup.

IIRC you suggested the fix in the first place anyway.
Let's get it fixed.

	Sam

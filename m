Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0K3TQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:16:23 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57416 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752617Ab0K3TQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:16:22 -0500
Date: Tue, 30 Nov 2010 20:16:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: kernel-janitors@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] suspend: constify platform_suspend_ops
Message-ID: <20101130191612.GB4156@ucw.cz>
References: <373762.60976.qm@smtp126.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <373762.60976.qm@smtp126.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-09 21:48:40, Lionel Debroux wrote:
> While at it, fix two checkpatch errors.
> Several non-const struct instances constified by this patch were added after
> the introduction of platform_suspend_ops in checkpatch.pl's list of "should
> be const" structs (79404849e90a41ea2109bd0e2f7c7164b0c4ce73).
> 
> Patch against mainline.
> 
> Changes since v1: deleted two spurious hunks, no longer adding "const"
> qualifier to pointers in platform_suspend_ops after seeing
> b4144e4f6e3b448d322095ca08af393682a69e33.

ack.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

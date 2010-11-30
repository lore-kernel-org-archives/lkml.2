Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0K3TPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:15:40 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57318 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752388Ab0K3TPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:15:39 -0500
Date: Tue, 30 Nov 2010 20:15:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: kernel-janitors@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] hibernation: constify platform_hibernation_ops
Message-ID: <20101130191530.GA4156@ucw.cz>
References: <285897.77932.qm@smtp128.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <285897.77932.qm@smtp128.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-09 21:48:49, Lionel Debroux wrote:
> Patch against mainline.
> 
> Changes since v1: added one hunk; no longer adding "const" qualifier to
> pointers in platform_hibernation_ops after seeing
> b4144e4f6e3b448d322095ca08af393682a69e33.
> ---
> 
> Subject: [PATCH 3/3] hibernation: constify platform_hibernation_ops
> 
> Derived from the grsecurity patch.
> 
> Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>

ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

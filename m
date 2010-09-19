Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0ISVoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 17:44:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37545 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752547Ab0ISVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 17:44:03 -0400
Date: Sun, 19 Sep 2010 23:43:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Lars Lindley <lindley@coyote.org>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: Re: [PATCH 2/7] w35und: Remove remaining typedef declarations
Message-ID: <20100919214355.GE12416@elf.ucw.cz>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
 <1284888523-9625-2-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284888523-9625-2-git-send-email-penberg@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-09-19 12:28:38, Pekka Enberg wrote:
> This patch removes remaining typedef declarations from the w35und driver. Most
> of them were unused so I just killed them off completely.
> 
> Cc: Lars Lindley <lindley@coyote.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

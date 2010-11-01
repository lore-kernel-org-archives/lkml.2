Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0KATzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:55:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42637 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752624Ab0KATze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:55:34 -0400
Date: Mon, 1 Nov 2010 20:55:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] w35und: Rename wbhal_s.h to wbhal.h
Message-ID: <20101101195510.GC22934@elf.ucw.cz>
References: <1288641006-30100-1-git-send-email-penberg@kernel.org>
 <1288641006-30100-2-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288641006-30100-2-git-send-email-penberg@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-11-01 21:50:06, Pekka Enberg wrote:
> This patch renames the wbhal_s.h header file to wbhal.h now that it contains
> both structure and function definitions.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

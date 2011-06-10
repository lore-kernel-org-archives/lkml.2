Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1FJUA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:00:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:37295 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab1FJUA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:00:57 -0400
From: Richard Weinberger <richard@nod.at>
To: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] um, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 22:00:50 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.3; x86_64; ; )
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com> <1307711457-17613-1-git-send-email-minipli@googlemail.com>
In-Reply-To: <1307711457-17613-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106102200.50655.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 10 Juni 2011, 15:10:57 schrieb Mathias Krause:
> The address limit is already set in flush_old_exec() so this
> set_fs(USER_DS) is redundant.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Richard Weinberger <richard@nod.at>

Applied.

Thanks,
//richard

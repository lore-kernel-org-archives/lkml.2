Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1FNGdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:33:44 -0400
Received: from linux-sh.org ([111.68.239.195]:60334 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1FNGdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:33:41 -0400
Date: Tue, 14 Jun 2011 15:33:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh, exec: remove redundant set_fs(USER_DS)
Message-ID: <20110614063330.GD17891@linux-sh.org>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org> <1307711448-16289-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307711448-16289-1-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:10:48PM +0200, Mathias Krause wrote:
> The address limit is already set in flush_old_exec() so those calls to
> set_fs(USER_DS) are redundant.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Applied, thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1GSCVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 22:21:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1GSCVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 22:21:33 -0400
Date: Tue, 19 Jul 2011 03:21:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110719022129.GN11013@ZenIV.linux.org.uk>
References: <20110718194703.GI11013@ZenIV.linux.org.uk>
 <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <alpine.LSU.2.00.1107181533590.3909@sister.anvils>
 <20110718231738.GJ11013@ZenIV.linux.org.uk>
 <20110718232114.GK11013@ZenIV.linux.org.uk>
 <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
 <20110718234012.GL11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107181903350.23830@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107181903350.23830@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 07:07:54PM -0700, Hugh Dickins wrote:

> It looked sane, but in fact was insane.  Enough testing for now,
> I say it's good to go, if you fold in this small adjustment...

Folded and pushed...

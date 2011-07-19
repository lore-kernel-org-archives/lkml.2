Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1GSCOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 22:14:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1GSCOd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 22:14:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1107181903350.23830@sister.anvils>
References: <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils> <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <alpine.LSU.2.00.1107181533590.3909@sister.anvils> <20110718231738.GJ11013@ZenIV.linux.org.uk>
 <20110718232114.GK11013@ZenIV.linux.org.uk> <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
 <20110718234012.GL11013@ZenIV.linux.org.uk> <alpine.LSU.2.00.1107181903350.23830@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 19:14:10 -0700
Message-ID: <CA+55aFwafi1p=RgrwsauKw+40mcUx9nOs4pkvSFsGBmsb25dDQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 7:07 PM, Hugh Dickins <hughd@google.com> wrote:
>
> It looked sane, but in fact was insane.  Enough testing for now,
> I say it's good to go, if you fold in this small adjustment...

Good catch, that test was indeed the wrong way around. Thanks.

                  Linus

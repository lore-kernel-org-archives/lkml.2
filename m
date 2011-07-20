Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1GTEwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 00:52:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab1GTEwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 00:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110720014014.GV11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils> <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <20110719234550.GR11013@ZenIV.linux.org.uk> <20110719235215.GS11013@ZenIV.linux.org.uk>
 <20110719235515.GT11013@ZenIV.linux.org.uk> <20110720104721.03a2a2f0@notabene.brown>
 <20110720014014.GV11013@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Jul 2011 21:52:22 -0700
Message-ID: <CA+55aFy8G-4PPwgbFUiiNa+FUeNibRA6uh6cjRyfoB5aTTDv5w@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: NeilBrown <neilb@suse.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 6:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Grr...  I can amend and push again, of course, but I've no idea if Linus
> has already pulled into his tree ;-/  Still not there in tree on hera,
> but that's not saying much.  Linus?

I fetched it, amended it, and merged the amended commit.

                  Linus

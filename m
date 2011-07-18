Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1GRX2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 19:28:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab1GRX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 19:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110718232114.GK11013@ZenIV.linux.org.uk>
References: <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <alpine.LSU.2.00.1107181135170.2722@sister.anvils> <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils> <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <alpine.LSU.2.00.1107181533590.3909@sister.anvils> <20110718231738.GJ11013@ZenIV.linux.org.uk>
 <20110718232114.GK11013@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 16:27:53 -0700
Message-ID: <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 4:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Linus, are you OK with me slapping your s-o-b on it?

Yup.

And it feels so right that I think we should just do it for 3.0.

I was planning on doing that today, but I guess can delay it too. I'm
at the Intel tech days tomorrow and the day after, but there's WiFi
there and I'll have my laptop. The slightly bigger problem is that it
will move the next merge window even further into my upcoming
vacation, but I was planning on having the laptop with me there too,
so whatever...

I assume I'll get the cifs_get_root() fix at the same time.

                         Linus

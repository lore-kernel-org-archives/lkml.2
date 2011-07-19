Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1GSCiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 22:38:12 -0400
Received: from void.printf.net ([89.145.121.20]:45320 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1GSCiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 22:38:11 -0400
From: Chris Ball <cjb@laptop.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
References: <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
	<CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
	<alpine.LSU.2.00.1107181533590.3909@sister.anvils>
	<20110718231738.GJ11013@ZenIV.linux.org.uk>
	<20110718232114.GK11013@ZenIV.linux.org.uk>
	<CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
	<20110718234012.GL11013@ZenIV.linux.org.uk>
	<alpine.LSU.2.00.1107181903350.23830@sister.anvils>
	<CA+55aFwafi1p=RgrwsauKw+40mcUx9nOs4pkvSFsGBmsb25dDQ@mail.gmail.com>
	<CA+55aFzMP3oYV9G8bzskkyNEpqcHGSBR3rWCF_TWF4QhOMmR8A@mail.gmail.com>
	<20110719022305.GO11013@ZenIV.linux.org.uk>
Date: Mon, 18 Jul 2011 22:37:44 -0400
In-Reply-To: <20110719022305.GO11013@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 19 Jul 2011 03:23:05 +0100")
Message-ID: <m2livv9err.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 18 2011, Al Viro wrote:
>> Oh, and Al - just fold the thing into the original patch rather than
>> carry a buggy patch and the fix around. You might as well credit Hugh
>> as author for the whole thing, since he ended up being not just the
>> one to find the problem, but describe the solution anyway and fix the
>> patch.
>
> Umm...  Is there any convenient way to make git commit --amend change
> the author of commit?

`git commit --amend --author="Foo Bar <foo@bar>"` works fine.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

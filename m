Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0IWBcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:32:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0IWBcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gmpspNTViIkkwQh3MPVMFoWdXe22MzsFirLsiBLZd6t8RTnhb5ANKPAvfzKLXMfElZ
         gl4VoZ2IFzY0DFs8G4Xj11gCc5bHcMgIz5XFJNTo+0U39lsWOloX3UWRLpZrwp5AV2y7
         NUGgrHain0NeSWl2GFn9a4Za3i5OU405cm/rE=
MIME-Version: 1.0
In-Reply-To: <20100923112004.b47923b7.sfr@canb.auug.org.au>
References: <20100923112004.b47923b7.sfr@canb.auug.org.au>
Date: Wed, 22 Sep 2010 20:32:41 -0500
Message-ID: <AANLkTimXtigjQwpL6i46JTiuREdLnr7Yh+2ZCuPfy06G@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about that - we merged one of Jeff's patches (in a series) out
of order by three hours due to review comments.  Should be ok now -
verifying.

On Wed, Sep 22, 2010 at 8:20 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/file.c: In function 'cifs_writepages':
> fs/cifs/file.c:1365: error: 'struct cifs_sb_info' has no member named 'tcon'
> fs/cifs/file.c:1365: error: 'struct cifs_sb_info' has no member named 'tcon'
> fs/cifs/file.c:1366: error: 'struct cifs_sb_info' has no member named 'tcon'
>
> Caused by commit 2eff6be391f00d606b43e60d9727b70c44917b7e ("cifs:
> temporarily rename cifs_sb->tcon to ptcon to catch stragglers").
>
> Really, such testing code should not be in linux-next ...
>
> I have used the cifs tree fomr next-20100921 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Thanks,

Steve

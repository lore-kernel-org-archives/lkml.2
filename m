Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2ASAbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:31:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64872 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2ASAbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120119110153.7ffa3312b2943386750ac7ed@canb.auug.org.au>
References: <20120119110153.7ffa3312b2943386750ac7ed@canb.auug.org.au>
Date: Wed, 18 Jan 2012 18:31:11 -0600
Message-ID: <CAH2r5mv-dbFM0jf9V+=y-N8tuQey=MgcfToPzBg3hRvFbCWeBA@mail.gmail.com>
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

I already fixed that and merged it into cifs-2.6.git.   If you repull
you will get the fix for that.

On Wed, Jan 18, 2012 at 6:01 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/connect.c: In function 'cifs_set_vol_auth':
> fs/cifs/connect.c:3843:17: error: 'CIFSSEC_MUST_LANMAN' undeclared (first use in this function)
> fs/cifs/connect.c:3843:17: note: each undeclared identifier is reported only once for each function it appears in
>
> Caused by commit 8a8798a5ff90 ("cifs: fetch credentials out of keyring
> for non-krb5 auth multiuser mounts").
>
> I have used the cifs tree from next-20120118 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Thanks,

Steve

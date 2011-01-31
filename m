Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1AaDZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 22:25:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1AaDZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 22:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PQZn2ydEFi9nPOAkts8ozV9oIgA7h/oO31dycpT3pczRLRuS1AMs0Sl9DuHJz7PGM1
         2q505mtfZrV3QIu40sQYXc6jJlqcNNfC9qclfVlEez1uJ8p1AzbNQipV5i96E+d0L4h7
         M6sX7xg2YX69dvc7aTPrgIz7YORaRS2FIwI5c=
MIME-Version: 1.0
In-Reply-To: <20110131132743.4ae5d4ae.sfr@canb.auug.org.au>
References: <20110131132743.4ae5d4ae.sfr@canb.auug.org.au>
Date: Sun, 30 Jan 2011 21:25:08 -0600
Message-ID: <AANLkTineJds4VXmYP7q68C5mk_KD_TyMT7Fj=KE0BupJ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this Friday but had a pending merge request (upstream) in so
was holding off.  I now have merged the fix for this crypto cleanup
warning.

On Sun, Jan 30, 2011 at 8:27 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> fs/cifs/link.c: In function 'symlink_hash':
> fs/cifs/link.c:58: warning: 'rc' may be used uninitialized in this function
>
> and, indeed, it may be ...
>
> Introduced by commit ee2c9258501f83d3ed0fd09ce5df1cec53312cf0 ("cifs:
> More crypto cleanup (try #2)").
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Thanks,

Steve

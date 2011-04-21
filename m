Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1DUK7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:59:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54901 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1DUK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=m/M347LeRr1/suW+Ize4XkzmW/pMoei0FSxWzFjbvLFcHQdrq1D6bFomZuR/5vPfdv
         rfDESCph/XDhw6Q6gtf41Me4bWJna6pPYuIrMvgpDYYLZwCVNZ36RsDgiKm4cj+qQqvI
         +FmG41dlI4/wPFQAWfkov6weRYfDHHkn36Ji8=
MIME-Version: 1.0
In-Reply-To: <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
 <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
 <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com> <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
 <BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com> <87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
 <BANLkTinXVDrLnMOo17pqua5+38yQsezG6g@mail.gmail.com> <87tydtm41s.fsf@tucsk.pomaz.szeredi.hu>
 <BANLkTikJ_7ZZ+1uC=0RBmKmxqFhVyLiYsw@mail.gmail.com> <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 21 Apr 2011 12:59:01 +0200
X-Google-Sender-Auth: FKpcuD0kGkRSXVuR-lno8QkiNXk
Message-ID: <BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Phillip Lougher <phillip.lougher@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2011 11:08, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Michal Suchanek <hramrach@centrum.cz> writes:
>
>> Can you put up a branch with both overlayfs and xattrs?
>>
>> I would like to point people at a repo with working implementation and
>> mirroring the kernel tree to add one patch is a bit overkill.
>
> Okay, added the tmpfs-xattr patch to the overlayfs.v8 branch.
>

Okay, I built a small live system using this branch and it boots without errors.

Now it's time to build a larger image I guess.

Thanks

Michal

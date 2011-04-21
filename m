Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DUTRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:17:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33421 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1DUTRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=mHS71xl8zTRRHkojBe09D4PUeljdxqy1VGMDB8uk1NbMuZM9xiinEd7oWYof50BdPa
         4S3mwk2TQEoY4jBRnpRf+J4Fb4uLFEjDa7JhsggiHw7xxREC0J7q/VeA+SGjEbpfx+PS
         SGj0r2WiV+WD9PyjM4WpTVB/rgPCZsPFWKZmI=
MIME-Version: 1.0
In-Reply-To: <87vcy7v7me.fsf@tucsk.pomaz.szeredi.hu>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu> <BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
 <201104211658.35618.jordipujolp@gmail.com> <BANLkTimPN-9dmZKU25oLmUjtGQYDsyCvgw@mail.gmail.com>
 <BANLkTi=HER-HDjLpu8Hw4fCMUwE7ii54_g@mail.gmail.com> <87vcy7v7me.fsf@tucsk.pomaz.szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 21 Apr 2011 21:17:01 +0200
X-Google-Sender-Auth: fAN4NHnWqccXG8zON8_8StuhnMA
Message-ID: <BANLkTi=XzwpqoJEKasjN4eUfRJDOTwPFhg@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jordi Pujol <jordipujolp@gmail.com>,
        Phillip Lougher <phillip.lougher@gmail.com>,
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

On 21 April 2011 19:26, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Michal Suchanek <hramrach@centrum.cz> writes:
>
>> You will be probably interested in this log:
>>
>> ls: cannot access /usr/share/doc/ucb*: No such file or directory
>> ...
>> rmdir("/usr/share/doc/ucblogo.dpkg-new") = -1 ENOENT (No such file or directory)
>> rmdir("/usr/share/doc/ucblogo.dpkg-tmp") = -1 ENOENT (No such file or directory)
>> mkdir("/usr/share/doc/ucblogo.dpkg-new", 0) = 0
>> chown32("/usr/share/doc/ucblogo.dpkg-new", 0, 0) = 0
>> chmod("/usr/share/doc/ucblogo.dpkg-new", 0755) = 0
>> utime("/usr/share/doc/ucblogo.dpkg-new", [2011/04/21-15:37:05,
>> 2008/06/08-11:38:17]) = 0
>> rename("/usr/share/doc/ucblogo.dpkg-new", "/usr/share/doc/ucblogo") =
>> -1 EOPNOTSUPP (Operation not supported)
>
> Oops, stupid mistake.
>
> Following patch should fix it.
>

Yes, with the additional patch package installation now works.

Thanks

Michal

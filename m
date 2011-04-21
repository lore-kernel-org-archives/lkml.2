Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1DUPWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:22:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55761 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1DUPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=WiKNbSxgDXWBlXCvr0Tc5qE1NfhmhQq5vP6dGFb/dEbrxIJ6+Qiar4YL+giLH6nvdy
         A8SQpFqRHCce3lvqRLNuZYVtlyYoTdpgLxSUk0yzI/srQ+4HjFO6qRD5ebyTfiYhK6MY
         YO0e774TtDiE0dT7q4D9EaRXxPDlwhqyZDCzI=
MIME-Version: 1.0
In-Reply-To: <201104211658.35618.jordipujolp@gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu> <BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
 <201104211658.35618.jordipujolp@gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 21 Apr 2011 17:22:28 +0200
X-Google-Sender-Auth: 7I5DhbQT6KKYGszvjjnwlGkmAOI
Message-ID: <BANLkTimPN-9dmZKU25oLmUjtGQYDsyCvgw@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
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

On 21 April 2011 16:58, Jordi Pujol <jordipujolp@gmail.com> wrote:
> A Dijous 21 Abril 2011 12:59:01, Michal Suchanek va escriure:
>> Now it's time to build a larger image I guess.
>
> Hello,
>
> I have done it, building a desktop image that contains kde4 and some services,
> The tests show that tmpfs is broken, it makes first operations but at some
> point it becomes erratic; that occurs in non-persistent mode, where
> overlayfs upperdir is on tmpfs, and in persistent mode also but in this case
> more user working is needed before tmpfs failure,
>
> in Linux single user mode I have installed the nvidia packages and driver
> using dpkg, only some files are installed, therefore I tried creating manually
> a required directory and in this manner the process has done some steps more.
>
> kernel source:
>
> http://livenet.selfip.com/ftp/debian/linux-2.6/linux-2.6.38-3.jpp.3-
> lnet_2.6.38-15.tar.bz2
>
> logs:
>
> http://livenet.selfip.com/ftp/debian/overlayfs/test-tmpfs-xattrs.tar.bz2
>

Yes, while the system appears to run generally fine unpacking dpkg
packages fails.

Thanks

Michal

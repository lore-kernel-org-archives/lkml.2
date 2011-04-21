Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1DUO6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:58:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40924 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1DUO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vqdTsi1Sa7KvZVLQYEV/twQf4Fss+z22Ysy8Dl+ft0N2X5utUggkn0OnjFiWhMKONd
         YFJo/uGvBUjNUIrUDZGuSmGwtQN93GOT8nlXceG62rxKY7Do6qbf8GKfA6dydCgUneSc
         f1iNrj8tHaYw7DDe4mEnkQiZ+Q8sf7KFyTEOQ=
From: Jordi Pujol <jordipujolp@gmail.com>
To: Michal Suchanek <hramrach@centrum.cz>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
Date: Thu, 21 Apr 2011 16:58:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-3.jpp.2-lnet-amd64; KDE/4.4.5; x86_64; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Phillip Lougher <phillip.lougher@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu> <BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
In-Reply-To: <BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211658.35618.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Dijous 21 Abril 2011 12:59:01, Michal Suchanek va escriure:
> Now it's time to build a larger image I guess.

Hello,

I have done it, building a desktop image that contains kde4 and some services,
The tests show that tmpfs is broken, it makes first operations but at some 
point it becomes erratic; that occurs in non-persistent mode, where 
overlayfs upperdir is on tmpfs, and in persistent mode also but in this case 
more user working is needed before tmpfs failure,

in Linux single user mode I have installed the nvidia packages and driver 
using dpkg, only some files are installed, therefore I tried creating manually 
a required directory and in this manner the process has done some steps more.

kernel source:

http://livenet.selfip.com/ftp/debian/linux-2.6/linux-2.6.38-3.jpp.3-
lnet_2.6.38-15.tar.bz2

logs:

http://livenet.selfip.com/ftp/debian/overlayfs/test-tmpfs-xattrs.tar.bz2

thanks,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com

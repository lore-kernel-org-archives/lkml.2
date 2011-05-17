Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1EQPNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:13:31 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61957 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1EQPNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=crcACzKwzYHrCQeNtRAfwejfueVQO/cMNfisCpG4e9ioRHtAEPeMPFH160odM//B5s
         pmoQhKxGaK9rnUcqrnDm3fRsfGIcIQcunEuEJ46ei74Vedblf8vsR4nLpu7cRvrFIaUe
         XnTG/GAG2QJpYl7n5dR03ZksMaIt00KxD3DaQ=
MIME-Version: 1.0
In-Reply-To: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Tue, 17 May 2011 17:13:09 +0200
X-Google-Sender-Auth: nayg3ORN9VuXdSk3u5hYmzusjLo
Message-ID: <BANLkTi=2Q5K+_PRqDrgG7DO_uBF=m7ejKA@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem v9
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On 17 May 2011 14:30, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Here's an updated version of the overlay filesystem.
>
> Git tree is here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v9
>
>
> Changes from v8 to v9
>
> - support xattr on tmpfs
>
> - fix build after split-up
>
> - fix remove after rename (reported by Jordi Pujol)
>
> - fix rename failure case
>

I built a live CD with v9 and it works for me.

As I understand it v9 only folds in the extra v8 patches so I expected
no less ;-)

Thanks

Michal

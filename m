Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2BHC4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:56:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52587 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2BHC4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:56:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Wv3PEJj5zKfK2o869ntxuU3V+Nv2dgKX1eDtk3zQ04dA@mail.gmail.com>
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
 <20120206160727.GA21048@tuxdriver.com> <20120207041958.GA32377@bombadil.infradead.org>
 <CAB=NE6VS79S4R6wQddQCqPfoYPyRbPzSdAYN2Mxfi-4G_sfCvg@mail.gmail.com> <CAB=NE6Wv3PEJj5zKfK2o869ntxuU3V+Nv2dgKX1eDtk3zQ04dA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 7 Feb 2012 18:55:40 -0800
X-Google-Sender-Auth: pwpUpJnOsUGQugZ0w-Cn-xePL7c
Message-ID: <CAB=NE6URWAgUgF+6bOsRBeeXnQ4VjYf1tWuUkkvMviCLOCxeqA@mail.gmail.com>
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, hauke@hauke-m.de,
        kernel-team@lists.ubuntu.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 5:19 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Mon, Feb 6, 2012 at 8:56 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>> Come to think of it.. we could bastardize Ubuntu's PPA packages for
>> mainline kernels, translate the deb packages into tar files and some
>> sort of grub-update or whatever scrip to run in the end? That still
>> seems like a lot of work.
>>
>> The current option allows us to use either distro kernels or whatever
>> you have installed.. not sure how else to improve this. Didn't we have
>> some sort of distro agnostic package crap? Maybe?
>
> Or -- Andy -- any chance we can get some of the deb contents unpacked
> into a distro-agostic tarball of some sort that we can use ? I ask
> given that you guys already host the sources and all that.

Just to not waste anyone's time it seems pkgadd from IRC has a
distro-agnostic dpkg -x type of solution in the works, that could use
these same debs.

http://paste.debian.net/155521/

  Luis

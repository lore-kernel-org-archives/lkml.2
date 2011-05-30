Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1E3C3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:29:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60678 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1E3C3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W7WWOe8hFLbMO0n2ak4WeKbufcSTyy11aljrK9aTzq6sYflZATgke1eHo5LS5mIOgY
         b+v+Q+Th7UgLpldyF+44z5vTfwSegxOI89l5xdc3m1qVqv2sHTkr3ZpHFnWqzrMCwRDo
         gLZeib5PvS8X0RBFj55QFOfQKxrPD3nJPL8Qo=
MIME-Version: 1.0
In-Reply-To: <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
	<BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
Date: Mon, 30 May 2011 10:29:04 +0800
Message-ID: <BANLkTinQkbJKyrCuevf5-6+3+MMiTbz1zw@mail.gmail.com>
Subject: Re: Linux 3.0-rc1
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 9:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Oh, and as some people already noticed, the numbering means that the
> tar-balls and patches are now in a new directory:
>
>    /pub/linux/kernel/v3.0
>
> (under "testing/", since that's what we do with -rc releases).
> However, I did *not* rename the git tree, because that would just be a
> huge inconvenience to git users, so it's still in the same old place
> and yes, that means that my git tree is still called "linux-2.6.git"
> on kernel.org. But it has the v3.0-rc1 tag in it.
>
> I'll probably add a symlink or something, if people really hate being
> reminded about our long history with the "2.6" numbering. But that
> won't be until closer to the real release, methinks.
>

You are not alone, Linus, David also has net-2.6 and net-next-2.6. :)

Thanks for the release!

(/me is looking forward to seeing you in Japan...)

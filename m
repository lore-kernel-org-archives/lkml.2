Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2CCE5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 23:57:22 -0500
Received: from mail-qy0-f179.google.com ([209.85.216.179]:56840 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2CCE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 23:57:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of lucas.de.marchi@gmail.com designates 10.224.97.130 as permitted sender) smtp.mail=lucas.de.marchi@gmail.com; dkim=pass header.i=lucas.de.marchi@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAMOw1v5TpPiQG4BLdtDzDTgqdf+9Y49cLvgpD+x0-3nY3Xg12A@mail.gmail.com>
References: <CAMOw1v5TpPiQG4BLdtDzDTgqdf+9Y49cLvgpD+x0-3nY3Xg12A@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sat, 3 Mar 2012 01:56:58 -0300
Message-ID: <CAKi4VALPD8_ZE-xjLzcSzdBV05f3tKCy059DQveNOGp78i1nzw@mail.gmail.com>
Subject: Re: [ANNOUNCE] kmod 6
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 01:39, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> Hey!! kmod 6 is out:
>
> ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-6.tar.xz
> ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-6.tar.sign
>
> The first noticeable change is that we are now hosting kmod on
> kernel.org. The new repository can be found here:
>
> http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=summary
>
> This version is very shorter than previous and this only indicates we
> are reaching a maintenance phase. Everyone is advised to upgrade from
> previous versions (including distros packaging kmod 5 and wanting to
> freeze in that version). There were some important bugs fixed. Check
> NEWS file for more information:
> http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=blob;f=NEWS;h=4181097b8334e6145e556fc12ee42922d5751fb3;hb=HEAD

This link is wrong, it should be the following one:

http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=blob;f=NEWS;h=809cfaf90526e0579b08ad3661ca4593e726a6ba;hb=26906fe73eb8ca40761c0378ccdc1f2ed9a15a08

Lucas De Marchi

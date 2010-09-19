Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0ISJyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:54:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57300 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab0ISJyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:54:21 -0400
Date: Sun, 19 Sep 2010 11:54:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
Message-ID: <20100919095419.GC25704@merkur.ravnborg.org>
References: <7vhbhmxyeb.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vhbhmxyeb.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 07:25:32PM -0700, Junio C Hamano wrote:
> In 60f33b8 (kconfig: get rid of stray a.o, support ncursesw, 2006-01-15),
> support to link menuconfig with ncursesw library was added.  To compute
> the linker command option -l, we check "libncursesw.{so,a,dylib}" to allow
> ncursesw to be used as a replacement ncurses.  However, when checking what
> header file to include, we do not check /usr/include/ncursesw directory.
> 
> Add /usr/include/ncursesw to the list of directories that are checked.
> With this patch, on my Debian Lenny box with libncursesw5-dev package but
> not libncurses5-dev package, I can say "make menuconfig".
> 
> Signed-off-by: Junio C Hamano <gitster@pobox.com>

Except for the missing patch subject then it looks OK.

Suggested subject:
kconfig: fix menuconfig on debian lenny

Add as this is a fix we should Cc: <stable@kerne.org>?

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

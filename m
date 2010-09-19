Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0ISSVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 14:21:38 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:60526 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0ISSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 14:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=w/78F6B8NUCAamTs0y4VsWvG+11FGIGO
	RiyD7RiR4DZCgDfcAY4bjbNz7kYtd1F5e8FbfvvjfZqp9kDjAtBHUX/PIO5a/dCD
	WK+dOCPhrmZmjwgkNl9y0tWsZahZTJq7O2GgSG9Z6cml1702JAYhbiArLj4xU8SG
	5zU7b9XJiMY=
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
References: <7vhbhmxyeb.fsf@alter.siamese.dyndns.org>
 <20100919095419.GC25704@merkur.ravnborg.org>
From: Junio C Hamano <junio@pobox.com>
Date: Sun, 19 Sep 2010 11:21:21 -0700
In-Reply-To: <20100919095419.GC25704@merkur.ravnborg.org> (Sam Ravnborg's
 message of "Sun\, 19 Sep 2010 11\:54\:19 +0200")
Message-ID: <7v8w2xy4pq.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: B8EE3306-C41A-11DF-9733-030CEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> On Sat, Sep 18, 2010 at 07:25:32PM -0700, Junio C Hamano wrote:
>> In 60f33b8 (kconfig: get rid of stray a.o, support ncursesw, 2006-01-15),
>> support to link menuconfig with ncursesw library was added.  To compute
>> the linker command option -l, we check "libncursesw.{so,a,dylib}" to allow
>> ncursesw to be used as a replacement ncurses.  However, when checking what
>> header file to include, we do not check /usr/include/ncursesw directory.
>> 
>> Add /usr/include/ncursesw to the list of directories that are checked.
>> With this patch, on my Debian Lenny box with libncursesw5-dev package but
>> not libncurses5-dev package, I can say "make menuconfig".
>> 
>> Signed-off-by: Junio C Hamano <gitster@pobox.com>
>
> Except for the missing patch subject then it looks OK.
> Suggested subject:
> kconfig: fix menuconfig on debian lenny

Sorry, the missing subject really was sloppy of me, and thanks.

> Add as this is a fix we should Cc: <stable@kerne.org>?

I don't think the fix deserves to be in stable.  It does not look like
60f33b8 made it possible to use ncursesw on a box like mine so the patch
is not evan an regression-fix.

> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks; is it my responsibility to follow-up the thread with identical
patch with updated Subject and with your Ack, hoping somebody in kbuild
team would pick it up?


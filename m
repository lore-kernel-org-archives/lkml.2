Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0IMSJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:09:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60364 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0IMSJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ig1SD7B4BY5IBXpujd+tvSanByRJKFBdI6SMW9Mk4R256cYqYngVHYUYovUrpe6K4s
         2UoLbZYrBwdXJwFojT/slpa8Qmsa7q0vdt4tjDLO4DU9vb3r2jh3JiF7C9sMW9P8IQvh
         LZpubEq4b+fVo9OccIcB5chK8kuKm1hAfFbUI=
MIME-Version: 1.0
In-Reply-To: <fdc11b1532157d10fb58d3642565d496da794195.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<fdc11b1532157d10fb58d3642565d496da794195.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
Date: Mon, 13 Sep 2010 20:09:45 +0200
X-Google-Sender-Auth: DZMWU62nv52b2wfm3Pw90Ibl_xo
Message-ID: <AANLkTikmj4KwRYgrJqzTdKpMMGA6H3uVuomiE3Q8GmtH@mail.gmail.com>
Subject: Re: [PATCH 1/9] arch/m68k: Removing dead GG2 config option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Roman Zippel <zippel@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>, John Stultz <johnstul@us.ibm.com>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 14:41, Christian Dietrich
<qy03fugy@stud.informatik.uni-erlangen.de> wrote:
> CONFIG_GG2 doesn't exist in Kconfig, therefore removing
> all references to it from the source.
>
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Applied

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

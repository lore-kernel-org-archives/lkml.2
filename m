Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1KBKGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:06:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40175 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1KBKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <20111102093935.GB20916@elte.hu>
References: <20111028070336.GF12995@elte.hu>
	<CAMuHMdUSyNcbmmXjFqSVQmsSqGS5xKFt4DSnskkg80UyWoJjLQ@mail.gmail.com>
	<20111028075432.GB8626@elte.hu>
	<20111028120856.GA29174@citd.de>
	<20111028122902.GA25323@elte.hu>
	<20111028130535.GA2752@citd.de>
	<20111102084124.GB18771@elte.hu>
	<4EB1084F.4020206@suse.cz>
	<20111102091747.GH18903@elte.hu>
	<4EB10C3D.6090906@suse.cz>
	<20111102093935.GB20916@elte.hu>
Date: Wed, 2 Nov 2011 12:06:38 +0200
X-Google-Sender-Auth: Qy5gUVrLlNclYT0u25HT_U4UnzA
Message-ID: <CAOJsxLFjZJKkjA9yTQ1T2YqAv_fzvWwWViyraAA9940cTKF2_w@mail.gmail.com>
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Marek <mmarek@suse.cz>, Matthias Schniedermeyer <ms@citd.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 11:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> As I said, make kvmconfig is fine with me, if it's just this single case.
>
> Great, thanks!

I applied Sasha's patch. We're happy to revisit the Kbuild changes if
someone comes up with something more generic in the future.

                        Pekka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0H3UmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:42:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42247 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0H3UmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=B+8eVIR/3V9XLvoNgKreCWYsqmrI/P7t3HToC9Yjs7HUyh5uUe8p7k7u6IwekPe3Ao
         azasLzA+rbDnLiCfyD2fkX3efuAQrOD3Lun0a5RdShQATBGQljciuZggDt10TFjJN9fq
         TbdWae/ndR+1iT9Xn3scxK+q5xyQN64yRbvw8=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTinaSDHmoprPdQxsoS50uMTyRE56W9jeVELN0ATp@mail.gmail.com>
References: <bug-16881-17162@https.bugzilla.kernel.org/>
	<201008301928.o7UJS30m021739@demeter1.kernel.org>
	<AANLkTinaSDHmoprPdQxsoS50uMTyRE56W9jeVELN0ATp@mail.gmail.com>
Date: Mon, 30 Aug 2010 21:42:15 +0100
Message-ID: <AANLkTikLO2V0aEJGrVERp4z6s--apOXWDgobc-B+Vags@mail.gmail.com>
Subject: Re: [Bug 16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
 textures in 0 A.D.
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 9:31 PM, trapDoor <trapdoor6@gmail.com> wrote:
> ---------- Forwarded message ----------
> From:  <bugzilla-daemon@bugzilla.kernel.org>
> Date: Mon, Aug 30, 2010 at 8:28 PM
> Subject: [Bug 16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
> textures in 0 A.D.
> To: trapdoor6@gmail.com
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16881
>
>
> --- Comment #8 from Alex Deucher <alexdeucher@gmail.com>  2010-08-30
> 19:28:00 ---
>> I've installed 0ad here, however, I've never used it before.  Can you explain>
>> how to trigger the bug?
>
> I can't log on to bugzilla again, so replying from here.
>
> When you start the game please choose single player, default map
> (Arcadia) and accept (you can skip the players setup). The bug appears
> right away when the map has been loaded and the game begins. On my box
> that happens only on kernels 2.6.36-rc[1-3]. On 2.6.35.[0-4] it's OK.
>
> --
> Thanks,
> Tomasz
>

One more thing. I have no support for S3TC compressed textures enabled
in mesa and that turns up a performance warning message. I just accept
it to get to the initial game menu. Lack of S3TC support causes
performance slowdown on both 'good' and 'bad' kernels but this is
rather irrelevant for the case we are testing. What's important is to
keep the same settings within libdrm, mesa etc when running the game
on 2.6.35.x and 2.6.36-rcx

-- 
Thanks,
Tomasz

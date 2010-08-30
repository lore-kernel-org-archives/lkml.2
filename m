Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0H3Ubz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:31:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37838 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab0H3Ubx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=nzdezl3o7RZQ+gmGLHh7fhWJY1GJKrQymMsHSOTpwi1iEWOok0o0v+kTRGibYOESxr
         Wm2xI3/dC/V5T5xlxPzNsvwxylz7dLOjhPBLUulftPeBU9Lgx1MJsNMcCa93gHEAKb9i
         Gm0MLtmr4wN4/y8KQb2wwEddXwXHO9wKMdYhE=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <201008301928.o7UJS30m021739@demeter1.kernel.org>
References: <bug-16881-17162@https.bugzilla.kernel.org/>
	<201008301928.o7UJS30m021739@demeter1.kernel.org>
Date: Mon, 30 Aug 2010 21:31:52 +0100
Message-ID: <AANLkTinaSDHmoprPdQxsoS50uMTyRE56W9jeVELN0ATp@mail.gmail.com>
Subject: Fwd: [Bug 16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
 textures in 0 A.D.
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From:  <bugzilla-daemon@bugzilla.kernel.org>
Date: Mon, Aug 30, 2010 at 8:28 PM
Subject: [Bug 16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
textures in 0 A.D.
To: trapdoor6@gmail.com


https://bugzilla.kernel.org/show_bug.cgi?id=16881


--- Comment #8 from Alex Deucher <alexdeucher@gmail.com>  2010-08-30
19:28:00 ---
> I've installed 0ad here, however, I've never used it before.  Can you explain>
> how to trigger the bug?

I can't log on to bugzilla again, so replying from here.

When you start the game please choose single player, default map
(Arcadia) and accept (you can skip the players setup). The bug appears
right away when the map has been loaded and the game begins. On my box
that happens only on kernels 2.6.36-rc[1-3]. On 2.6.35.[0-4] it's OK.

-- 
Thanks,
Tomasz

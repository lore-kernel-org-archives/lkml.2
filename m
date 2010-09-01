Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0IAXek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:34:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34023 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0IAXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=c7YKj08BaQNCqMY1Yp+KI8BBpuvQzMdn4QMQ7FLwhH4G2smYR1kY/IhKwQzYt1mndW
         8G/AE0V58PJkFovSNarCbwpLDVsMrgJH2v0aYai+yKntaWt04rdclGgrJpwR923skAvL
         qgHZMDxCYjLpwAoCqmNugygbBZL4hdFQ3y4ps=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Thu, 2 Sep 2010 00:34:37 +0100
Message-ID: <AANLkTinzcZbQSfy7nuOVCvgXSjcxjEHhtSOM2GxhZ9hn@mail.gmail.com>
Subject: [Bug #16881 - FIXED after mesa upgrade] [Radeon-KMS] 2.6.36-rc[1-3]:
 missing textures in 0 A.D.
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16881

--- Comment #16 From  Alex Deucher   2010-08-31 07:47:15 ---
It's sort of random luck.  The vbo size was getting garbage values.
You'll also note that the vbo size errors in your kernel log are gone
with a newer mesa snapshot.


Hello,
Just wanted to confirm that after upgrading mesa, the maps in 0 A.D.
are rendered properly. Thanks a lot for pointing out the real source
of the problem and sorry I bothered you about non-kernel issues on
LKML. But apparently consistent behaviour of the game (always good on
2.6.35.X and always bad on .36-rcX) had made me think that it was
something kernel-related.

-- 
Regards,
Tomasz

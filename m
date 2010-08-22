Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0HVTlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 15:41:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61354 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0HVTll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 15:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=cH7Ljf3tmQs4uCSHDpH7cyutrAgdrPZUWEHsl2pbw7bG4i/KYPbGSD7z79wNXrumZk
         MMjelwUdlOGfAuDSGWKIgwMc8UOchdrS6qIBn0i9T5eXUwa5iQtgaLjC3qML4uipNBM9
         uwPagna2IQoHv7BEowdooeGW+RsGglgmVt348=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Sun, 22 Aug 2010 20:41:39 +0100
Message-ID: <AANLkTi=_XQfC7wGHKWHp7jtYPMKTOwHJkNnvkTddoLK5@mail.gmail.com>
Subject: [REGRESSION, Radeon-KMS] 2.6.36-rc1 - graphic issues in 0. A.D.
From: trapDoor <trapdoor6@gmail.com>
To: airlied@linux.ie
Cc: Alex Deucher <alexdeucher@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Just wanted to let you know about this before bisecting which
hopefully I will be able to start tomorrow. Please take a look at the
screenshots in below links to see the difference with rendering
textures in 0 A.D. alpha1 on kernel 2.6.35.3 and 2.6.36-rc1-git3. [0
A.D. - strategic game, OS clone of Age of Empires; home page:
http://wildfiregames.com/0ad/]

0 A.D. on kernel 2.6.35.3 [good]:
http://picasaweb.google.co.uk/104351852606666221362/0ad?authkey=Gv1sRgCMne0NqXpuzR_gE#5508312214769142226

0 A.D. on kernel 2.6.36-rc1-git3:
http://picasaweb.google.co.uk/104351852606666221362/0ad?authkey=Gv1sRgCMne0NqXpuzR_gE#5508312218519295058

Please note that in both cases only kernel was different. The other
components [including hardware] were in the same versions and had the
same options (like the game itself, xorg-ati drivers, mesa, libdrm
[S3TC disabled], etc.). So it must be kernel then.

-- 
Regards
Tomasz B.

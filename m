Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2JGLTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 07:19:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2JGLTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 07:19:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Please add back the asm-generic tree to linux-next
Date: Sun, 7 Oct 2012 11:18:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
References: <201210061254.45804.arnd@arndb.de> <20121007105139.bbb7f7603147965546c41309@canb.auug.org.au>
In-Reply-To: <20121007105139.bbb7f7603147965546c41309@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210071118.55086.arnd@arndb.de>
X-Provags-ID: V02:K0:lQakKrW58F1MqkPO1iqxh4+bPk+e4Kv36qmOJuytTTd
 TYpXzBS4cCKMEYynIr1VJN2kPXgK0fTV+h8tN08hCoO8FvzB1i
 fbgbsY10JhjTPYGCO9E5tmJ3TtITibdybOYcoR4ftCqdO7P4eu
 aiikG/WTN5ODKGHNu9qXnk4Dkg9hXvniKWvm2xg0zRMPdMG5H2
 PMDQIoPtQHLHy40nN7M4Oz6wfztJqOk89OXq+HL76ZvXejvO0i
 LJiHIyE8CrVTVmV/3vZfSR/qRiEQ3tn3hD4tKSA50hleVRoXzM
 byZasrDYV05fvFsAtPjifGNheFmeJsPYtIExp/OVTSUM0N7ivz
 18sevJWKlgDJRYE/+FZ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2012, Stephen Rothwell wrote:
> On Sat, 6 Oct 2012 12:54:45 +0000 Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > I haven't used my asm-generic git tree for the last year, but now I have some
> > patches in it again. I was (ab)using the arm-soc tree for now to get the
> > few patches into linux-next, but the URL is still listed in the MAINTAINERS
> > file and I should really be using that one, since it is mostly unrelated
> > to the arm-soc work.
> > 
> > Pleas add
> > git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git master
> 
> OK, I have added that back.  You used to use the "next" branch (which no
> longer exists) but are now using the master branch, correct?

Yes, that's right.

	Arnd

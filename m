Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2ISMS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:18:57 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:26221 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2ISMS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:18:56 -0400
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 08:18:55 EDT
Date: Wed, 19 Sep 2012 11:58:38 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andi Kleen <andi@firstfloor.org>
cc: pkg-sysvinit-devel@lists.alioth.debian.org, debian-devel@lists.debian.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: make tar*-pkg considered dangerous
In-Reply-To: <20120912161154.GB3289@khazad-dum.debian.net>
Message-ID: <Pine.BSM.4.64L.1209191152300.14400@herc.mirbsd.org>
References: <20120912031646.GV16230@one.firstfloor.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh dixit:

>From: Andi Kleen <andi@firstfloor.org>
>To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org

>The problem is that the tarball includes /lib/{modules,firmware},
>but on FC17 /lib is a symlink. tar when it unpacks the tarball
>replaces the symlink with the directory. So they end up
>with a /lib which only contains the new kernel files, but nothing else,

Well, this is both a bug in Fedora IMHO, and (objectively) a fault
of the users to not use “tar xzphf” for extracting.

bye,
//mirabilos
-- 
“It is inappropriate to require that a time represented as
 seconds since the Epoch precisely represent the number of
 seconds between the referenced time and the Epoch.”
	-- IEEE Std 1003.1b-1993 (POSIX) Section B.2.2.2

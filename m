Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2INNwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:52:16 -0400
Received: from mout.perfora.net ([74.208.4.194]:59162 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2INNwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:52:14 -0400
Date: Fri, 14 Sep 2012 09:51:54 -0400
From: Jim Rees <rees@umich.edu>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Jan Engelhardt <jengelh@inai.de>, "J. Bruce Fields" <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120914135154.GB8943@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
 <1347614276.26071.15.camel@thorin>
 <20120914123014.GB29160@umich.edu>
 <1347628693.3813.7.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347628693.3813.7.camel@thorin>
X-Provags-ID: V02:K0:SatT9EM1ZPz/wE4MJzLlse77E2tyctL/Q82zW7bbtcB
 IgGonsI8dPu6FjMsm0ecCvkil1Zz7xrwY5E5bphcF4M769R1J4
 XGZib9sb7EGrx+ktGBOw3qjER9eEnjY60qLmK4g3F/KiCsL7l/
 TO8pWFXTNKIxet+z2b5osudAw+wtQphSpFocbK5DLB44E/W9hD
 qhIYJHGLYn0JdWglDkUGEQ73o6CqT7yRAJIWYBRE+3Wh29TbEP
 XMgWihDOj7pT3lYUfkFrg2zBGNV9QXx8O6oTlQn0Pd/biu3UOh
 mQQbq2QVusp2UUYGyCqmBJInGnUJesqrdwnRGKPc0yNxZtRQw=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:

  [....]
  > Pure K&R:
  
  We can (and should) make it "const" too.

No "const" in K&R either.  But I think we can assume the kernel will be
compiled with something a bit more advance.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab0KQGLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:11:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49075 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab0KQGLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:11:48 -0500
MIME-Version: 1.0
In-Reply-To: <20101116204951.12146.21084.stgit@riker>
References: <20101116204917.12146.39851.stgit@riker> <20101116204951.12146.21084.stgit@riker>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Nov 2010 23:11:27 -0700
X-Google-Sender-Auth: BLiFcNGcpBHePsGDSR_wJF6EedE
Message-ID: <AANLkTinYZYR_QtS5-Nodpaf2MBBuaw06SW9pDCNQ9ov3@mail.gmail.com>
Subject: Re: [PATCH 1/5] scripts: dtc: Merge in changes from the dtc repository
To: John Bonesio <bones@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, jdl@jdl.com,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 1:49 PM, John Bonesio <bones@secretlab.ca> wrote:
> Pull in recent changes from the main dtc repository. These changes primarily
> allow multiple device trees to be declared which are merged by dtc. This
> feature allows us to include a basic dts file and then provide more information
> for the specific system through the merging functionality.
>
> Signed-off-by: John Bonesio <bones@secretlab.ca>
> ---
>
>  0 files changed, 0 insertions(+), 0 deletions(-)

???  Something isn't right in patch generation.

Also:

~/hacking/linux-2.6$ xc-6xx make -j3
  GEN     /home/grant/hacking/linux-2.6.build/6xx/Makefile
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig Kconfig
#
# configuration written to .config
#
  GEN     /home/grant/hacking/linux-2.6.build/6xx/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  HOSTCC  scripts/dtc/checks.o
In file included from /home/grant/hacking/linux-2.6/scripts/dtc/checks.c:21:
/home/grant/hacking/linux-2.6/scripts/dtc/dtc.h:37: fatal error:
util.h: No such file or directory
compilation terminated.
make[3]: *** [scripts/dtc/checks.o] Error 1
make[2]: *** [scripts/dtc] Error 2
make[1]: *** [scripts] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2
(devicetree/test) ~/hacking/linux-2.6$

Looks like the updated dtc is broken.

g.

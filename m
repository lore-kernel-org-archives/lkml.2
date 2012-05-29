Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2E2XhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:37:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63631 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2E2XhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:37:19 -0400
Message-ID: <1338334286.2658.536.camel@shawn-ssd>
Subject: include/linux/dynamic_debug.h:111:2: error: implicit declaration of
 function =?UTF-8?Q?=E2=80=98strstr=E2=80=99?=
From: shawn <shawnlandden@gmail.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2012 16:31:26 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  SHIPPED arch/arm/boot/compressed/lib1funcs.S
In file included from include/linux/kernel.h:23:0,
                 from
arch/arm/boot/compressed/../../../../lib/xz/xz_private.h:15,
                 from
arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:145,
                 from arch/arm/boot/compressed/decompress.c:50:
include/linux/dynamic_debug.h: In function
‘ddebug_dyndbg_module_param_cb’:
include/linux/dynamic_debug.h:111:2: error: implicit declaration of
function ‘strstr’ [-Werror=implicit-function-declaration]
  SHIPPED arch/arm/boot/compressed/ashldi3.S
  AS      arch/arm/boot/compressed/lib1funcs.o
  AS      arch/arm/boot/compressed/ashldi3.o
cc1: some warnings being treated as errors
make[2]: *** [arch/arm/boot/compressed/decompress.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/arm/boot/compressed/vmlinux] Error 2
make: *** [uImage] Error 2


git blame shows b48420c1d3019ce8d84fb8e58f4ca86b8e3655b8 as introducing
this call

-- 
-Shawn Landden


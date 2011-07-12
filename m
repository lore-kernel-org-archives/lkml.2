Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1GLUUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:20:22 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:46206 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1GLUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:20:21 -0400
Message-ID: <4E1CABBD.60901@udo.edu>
Date: Tue, 12 Jul 2011 22:17:01 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110709 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nir Tzachar <nir.tzachar@gmail.com>
CC: linux-kbuild@vger.kernel.org, mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig/nconf: prevent segfault on empty menu
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>	<1310282825-14509-1-git-send-email-lacombar@gmail.com>	<1310282825-14509-2-git-send-email-lacombar@gmail.com>	<CAMT+=WY84jaattF+9zYK7oiJLmn8_oGLB-mnGbOpK_4Rt0vRZg@mail.gmail.com>	<4E1AB992.3040309@udo.edu> <CAMT+=WZV4TGfXY0=BjYtNVRDuWw6r-facK=q2S6HVOUTB3KWEg@mail.gmail.com>
In-Reply-To: <CAMT+=WZV4TGfXY0=BjYtNVRDuWw6r-facK=q2S6HVOUTB3KWEg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090504070605030506030300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090504070605030506030300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

here is one more patch, which make empty title instead of "(null)".

Regards,
Andrej Gelenberg

On 07/11/2011 11:50 AM, Nir Tzachar wrote:
> On Mon, Jul 11, 2011 at 11:51 AM, Andrej Gelenberg
> <andrej.gelenberg@udo.edu> wrote:
>> Hello,
>>
>> it show already "There is no help available for this option." message on
>> F2. Only caption could be better as just "(null)". Besides ignore the
>> key is much better as segfault.
> 
> I agree. Then just add a proper caption and thats it.
> 
> Cheers.
> 
>> Regards
>> Andrej Gelenberg

--------------090504070605030506030300
Content-Type: text/plain;
 name="0001-nconfig-menu_get_prompt-return-if-no-promt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-nconfig-menu_get_prompt-return-if-no-promt.patch"

>From e5fa0e9a705c2e2092ba9c2879e85f8bef12f7f8 Mon Sep 17 00:00:00 2001
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Date: Tue, 12 Jul 2011 18:36:50 +0200
Subject: [PATCH] nconfig: menu_get_prompt() return "", if no promt

Help message box has "" as titled instead of "(null)" on empty menu in
nconf.

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
 scripts/kconfig/menu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 6a09cc4..0783d8e 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -476,7 +476,7 @@ const char *menu_get_prompt(struct menu *menu)
 		else if (menu->sym)
 			return menu->sym->name;
 	}
-	return NULL;
+	return "";
 }
 
 struct menu *menu_get_root_menu(struct menu *menu)
-- 
1.7.6


--------------090504070605030506030300--

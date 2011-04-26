Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab1DZIU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:20:58 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:42848 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab1DZIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:20:55 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Tue, 26 Apr 2011 10:19:37 +0200
Subject: RE: [PATCH v4] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH v4] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcwDpAAQEUmQW4NFRsKsmWWpSTJTxgARfFFg
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA33954612EB@EXDCVYMBSTM005.EQ1STM.local>
References: <1302173946-25363-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110425235328.GA31473@kroah.com>
In-Reply-To: <20110425235328.GA31473@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3Q8LDYa016272


> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: den 26 april 2011 01:53
> 
> To have a patch accepted into the staging tree there are only 2 simple
> requirements:
> 	- proper license
> 	- code must build
> 
> Somehow the second one fails here, please at least test-build your code
> before sending it out, to do otherwise just wastes people's time and
> makes them grumpy:
> 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC [M]  drivers/staging/cg2900/mfd/cg2900_chip.o
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: (near
> initialization for â€˜cg2900_devs[0].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2941:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2941:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: error: (near
> initialization for â€˜cg2900_devs[1].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2946:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2946:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: error: (near
> initialization for â€˜cg2900_devs[2].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2951:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2951:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: error: (near
> initialization for â€˜cg2900_devs[3].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2956:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2956:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: error: (near
> initialization for â€˜cg2900_devs[4].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2961:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2961:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: error: (near
> initialization for â€˜cg2900_devs[5].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2966:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2966:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: error: (near
> initialization for â€˜cg2900_devs[6].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2971:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2971:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: error: (near
> initialization for â€˜cg2900_devs[7].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2976:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2976:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: error: (near
> initialization for â€˜cg2900_devs[8].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2981:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2981:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: error: (near
> initialization for â€˜cg2900_devs[9].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2986:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2986:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: error: (near
> initialization for â€˜cg2900_devs[10].idâ€™)
> drivers/staging/cg2900/mfd/cg2900_chip.c:2991:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2991:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3073:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3073:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3074:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3074:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3079:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3079:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3080:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3080:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3085:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3085:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3086:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3086:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3091:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3091:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3092:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3092:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3097:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3097:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3098:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3098:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3103:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3103:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3104:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3104:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3109:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3109:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3110:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3110:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3115:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3115:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3116:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3116:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3121:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3121:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3122:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3122:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3127:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3127:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3128:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3128:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:3133:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3133:3: warning:
> initialization from incompatible pointer type
> drivers/staging/cg2900/mfd/cg2900_chip.c:3134:3: error: unknown field
> â€˜data_sizeâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:3134:3: warning:
> initialization makes pointer from integer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c: In function â€˜set_plat_dataâ€™:
> drivers/staging/cg2900/mfd/cg2900_chip.c:3147:41: error: â€˜struct
> mfd_cellâ€™ has no member named â€˜platform_dataâ€™
> drivers/staging/cg2900/mfd/cg2900_chip.c:3147:37: warning:
> initialization from incompatible pointer type
> make[4]: *** [drivers/staging/cg2900/mfd/cg2900_chip.o] Error 1
> make[3]: *** [drivers/staging/cg2900/mfd] Error 2
> make[2]: *** [drivers/staging/cg2900] Error 2
> make[1]: *** [drivers/staging] Error 2
> make: *** [drivers] Error 2
> 
> 
> {sigh}
> 
> Please redo this, I obviously can't accept it as-is.
> 
> greg k-h

Hi Greg,

Sorry for all this trouble.
Of course I built the patches before sending them.
The problem is that the MFD core file has recently been updated and my
Linux base did not have this update included. I will update to latest
linux-next and correct the issue.

Trust me that I do not intentionally send patches that do not build.

Thanks,
/P-G
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

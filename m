Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab1DYXxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:53:35 -0400
Received: from kroah.org ([198.145.64.141]:51046 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab1DYXxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:53:33 -0400
Date: Mon, 25 Apr 2011 16:53:28 -0700
From: Greg KH <greg@kroah.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v4] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110425235328.GA31473@kroah.com>
References: <1302173946-25363-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302173946-25363-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 12:59:06PM +0200, Par-Gunnar Hjalmdahl wrote:
> This patch adds support for the ST-Ericsson CG2900
> Connectivity Combo controller (Bluetooth, FM, GPS).
> 
> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---

To have a patch accepted into the staging tree there are only 2 simple
requirements:
	- proper license
	- code must build

Somehow the second one fails here, please at least test-build your code
before sending it out, to do otherwise just wastes people's time and
makes them grumpy:

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC [M]  drivers/staging/cg2900/mfd/cg2900_chip.o
drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: (near initialization for ‘cg2900_devs[0].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2941:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2941:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2945:3: error: (near initialization for ‘cg2900_devs[1].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2946:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2946:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2950:3: error: (near initialization for ‘cg2900_devs[2].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2951:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2951:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2955:3: error: (near initialization for ‘cg2900_devs[3].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2956:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2956:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2960:3: error: (near initialization for ‘cg2900_devs[4].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2961:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2961:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2965:3: error: (near initialization for ‘cg2900_devs[5].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2966:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2966:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2970:3: error: (near initialization for ‘cg2900_devs[6].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2971:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2971:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2975:3: error: (near initialization for ‘cg2900_devs[7].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2976:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2976:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2980:3: error: (near initialization for ‘cg2900_devs[8].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2981:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2981:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2985:3: error: (near initialization for ‘cg2900_devs[9].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2986:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2986:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: warning: initialization makes integer from pointer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: error: initializer element is not computable at load time
drivers/staging/cg2900/mfd/cg2900_chip.c:2990:3: error: (near initialization for ‘cg2900_devs[10].id’)
drivers/staging/cg2900/mfd/cg2900_chip.c:2991:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:2991:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3073:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3073:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3074:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3074:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3079:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3079:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3080:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3080:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3085:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3085:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3086:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3086:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3091:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3091:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3092:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3092:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3097:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3097:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3098:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3098:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3103:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3103:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3104:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3104:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3109:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3109:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3110:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3110:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3115:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3115:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3116:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3116:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3121:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3121:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3122:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3122:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3127:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3127:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3128:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3128:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c:3133:3: error: unknown field ‘platform_data’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3133:3: warning: initialization from incompatible pointer type
drivers/staging/cg2900/mfd/cg2900_chip.c:3134:3: error: unknown field ‘data_size’ specified in initializer
drivers/staging/cg2900/mfd/cg2900_chip.c:3134:3: warning: initialization makes pointer from integer without a cast
drivers/staging/cg2900/mfd/cg2900_chip.c: In function ‘set_plat_data’:
drivers/staging/cg2900/mfd/cg2900_chip.c:3147:41: error: ‘struct mfd_cell’ has no member named ‘platform_data’
drivers/staging/cg2900/mfd/cg2900_chip.c:3147:37: warning: initialization from incompatible pointer type
make[4]: *** [drivers/staging/cg2900/mfd/cg2900_chip.o] Error 1
make[3]: *** [drivers/staging/cg2900/mfd] Error 2
make[2]: *** [drivers/staging/cg2900] Error 2
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2


{sigh}

Please redo this, I obviously can't accept it as-is.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab2K0Ije (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:39:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253Ab2K0Ijc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:39:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the battery tree
Date: Tue, 27 Nov 2012 08:38:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20121127155223.849e73a08fc1b382d4622ff8@canb.auug.org.au>
In-Reply-To: <20121127155223.849e73a08fc1b382d4622ff8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211270838.29360.arnd@arndb.de>
X-Provags-ID: V02:K0:FhKV/ECpL+ARPQRG36dPk+AtaW+FiZHiIl7o/pUhcuU
 7OiIUogDElReG8od1chxXS3/zrAVREka6T+mT5B2tOwEPsxn+8
 0fLkICnZD4ri6HMx1xUnAoZlcu+QFgF4horgUcQN4N7xpsRd6E
 wmQiIcaB6ggFHRZvtNlL5gfKa0XGCp+vNwSePn4G3dqgYoS9vq
 h6v3whu6CKrOx4sJ4Ed70irhvW2GJPWeq4KIHaUqV03Hn2+YuG
 1pdBvKVLZ6sW9vEUFZGzApMFeMSaz4DxzpHkinQjlGeLp1w8/m
 rw9opp6D2LyyVI7X0qxTVdtMJwxriGiwsqxT3ejFpZ2qRfUNNk
 KdW6Vp0fIcN8rRJs5IZE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2012, Stephen Rothwell wrote:

>   
>  -config AB8500_BATTERY_THERM_ON_BATCTRL
>  -	bool "Thermistor connected on BATCTRL ADC"
>  -	depends on AB8500_BM
>  -	help
>  -	  Say Y to enable battery temperature measurements using
>  -	  thermistor connected on BATCTRL ADC.
>  -
> + source "drivers/power/reset/Kconfig"
> + 
>   endif # POWER_SUPPLY
>   
>   source "drivers/power/avs/Kconfig"
> 


Looks good, thanks!

	Arnd

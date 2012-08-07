Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2HGAr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 20:47:27 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:52325
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177Ab2HGArX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 20:47:23 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.117;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0510HT003.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zz98dI9371Ic89bh1432I4015Izz1202hzz8275ch8275bh8275dhz2fh2a8h668h839hd24hf0ah107ah)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Dongjin Kim'" <tobetter@gmail.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: RE: [PATCH] video: s3c-fb: Fix compile error/warning if CONFIG_OF
 is not selected
Thread-Topic: [PATCH] video: s3c-fb: Fix compile error/warning if CONFIG_OF
 is not selected
Thread-Index: AQHNc9udW+oqsH1UsEm+AFchXJHhXJdNflaAgAAGU8s=
Date: Tue, 7 Aug 2012 00:47:15 +0000
Message-ID: <frxrb1h2wwxmdtvwst6uk43m.1344300433108@email.android.com>
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <1344261462-14183-5-git-send-email-dongjin.kim@agreeyamobility.net>,<000a01cd7433$07555780$16000680$%han@samsung.com>
In-Reply-To: <000a01cd7433$07555780$16000680$%han@samsung.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.43.181.89]
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
X-OriginatorOrg: agreeyamobility.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q770lVHa009044

Sorry, seems its my bad.

I took couple of commits from linaro kernel git for s3c-fb driver testing on my hardware and encountered the compile problem. Now I got your meaning, DT is not merged yet.

Thanks,
Dongjin.
----- ¿øº» ¸Ş½ÃÁö -----
º¸³½ »ç¶÷:Jingoo Han <jg1.han@samsung.com>
¹Ş´Â »ç¶÷:'Dongjin Kim' <tobetter@gmail.com>
ÂüÁ¶:Dongjin Kim <Dongjin.Kim@agreeyamobility.net>, 'Florian Tobias Schandinat' <FlorianSchandinat@gmx.de>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 'Jingoo Han' <jg1.han@samsung.com>
º¸³½ ½Ã°£:2012. 8. 7. 9:24 ¿ÀÀü
Á¦¸ñ:Re: [PATCH] video: s3c-fb: Fix compile error/warning if CONFIG_OF is not selected



On Monday, August 06, 2012 10:58 PM Dongjin Kim wrote:
>
> Change-Id: I5d7ff6f0070a10225d5b064b362d3d8f214787fd
> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> ---
>  drivers/video/s3c-fb.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index 8c8adb5..268be0c 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -1527,13 +1527,11 @@ static int s3c_fb_dt_parse_gpios(struct device *dev, struct s3c_fb *sfb,
>
>  static void s3c_fb_dt_free_gpios(struct s3c_fb *sfb)
>  {
> -     return 0;
>  }
>
> -static int s3c_fb_dt_parse_pdata(struct device *dev,
> -                                     struct s3c_fb_platdata **pdata)
> +static struct s3c_fb_platdata *s3c_fb_dt_parse_pdata(struct device *dev)
>  {
> -     return 0;
> +     return NULL;
>  }
>  #endif /* CONFIG_OF */


Um, DT is not yet merged to s3c-fb driver.
s3c_fb_dt_parse_pdata() and s3c_fb_dt_free_gpios() are not available.

So, this patch is unnecessary.

Best regards,
Jingoo Han


>
> --
> 1.7.9.5


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

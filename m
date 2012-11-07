Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2KGJaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:30:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:18368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2KGJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:30:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-8e-509a2a1e2dec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Marek Belisko'" <marek.belisko@open-nandra.com>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1351633534-20817-1-git-send-email-marek.belisko@open-nandra.com>
 <CAK5ve-+fE7T3U9KZ-C5-sZN9PUPq6RybCu+nv9UDb2x0bnarzw@mail.gmail.com>
In-reply-to: <CAK5ve-+fE7T3U9KZ-C5-sZN9PUPq6RybCu+nv9UDb2x0bnarzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds/tca6507: Add support for devicetree.
Date: Wed, 07 Nov 2012 18:30:06 +0900
Message-id: <000b01cdbcca$7925d2b0$6b717810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac28TBDbdh7Q4Z/WR4KZhgBtFoj/0QAfU2DQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfV05rVkBBp1njC0u75rDZrH1zTpG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKapi5lKrisXnH2mXED43+pLkZODgkBE4kTl7+wQdhi
	EhfurQeyuTiEBJYxSly9tJQVpujBylfsEIlFjBKLZ/6Ecn4xShxf8pcRpIpNQE3iy5fD7CC2
	iICxxM9jx8CKmAX2MkrMvrIPqmMKo8ThObOYuhg5ODgFgiW2zdcHaRAWcJJ48+YW2CAWAVWJ
	lyc3M4KU8ArYSqx8BnYer4CgxI/J91hAbGYBLYn1O48zQdjyEpvXvGUGKZcQUJd49FcX4gQj
	if3PjzJDlIhI7HvxDmq6gMS3yYdYIMplJTYdYAY5TEJgE7vEp1P7oSEhKXFwxQ2WCYwSs5Bs
	noVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRkiMSe1gXNlgcYhRgINR
	iYd3QvrMACHWxLLiytxDjBIczEoivAy8swKEeFMSK6tSi/Lji0pzUosPMfoAXT6RWUo0OR8Y
	/3kl8YbGxiZmJqYm5pam5qY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MM5Srjy9KLvp
	/tTf5rq1nZKzW1Y95ebbmMXz8Hv7loNLb66/9mDjsmslYg+WBr92vvjG4ktxTv+GB/PW+HZZ
	iT+7rSSWmZu0rGbziY6qXkUJxQX+bg4q0xq1JxkwrtPsEnD/dOnrXuWUr04i9Y6Mb86VVIX2
	HjA8MV2Iqb9q04wLl7WaJb8v0lZiKc5INNRiLipOBACOWJEi3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAV05rVkBBncP6Flc3jWHzWLrm3WM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmNE1dylRwWb3i
	7DPjBsb/Ul2MnBwSAiYSD1a+YoewxSQu3FvP1sXIxSEksIhRYvHMn+wQzi9GieNL/jKCVLEJ
	qEl8+XIYrENEwFji57FjYEXMAnsZJWZf2QfVMYVR4vCcWUxdjBwcnALBEtvm64M0CAs4Sbx5
	cwtsEIuAqsTLk5sZQUp4BWwlVj5jAwnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQcgkB
	dYlHf3UhTjCS2P/8KDNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgCH4mtYNxZYPFIUYBDkYlHt4J6TMDhFgTy4orcw8xSnAwK4nwMvDO
	ChDiTUmsrEotyo8vKs1JLT7E6AP050RmKdHkfGByySuJNzQ2MTOyNDKzMDIxN8chrCTO2+yR
	EiAkkJ5YkpqdmlqQWgQzjomDU6qBUehATNfTxRVKZ2PuLRK/Mc894Mq9nbrTn/gekTrmy7/Z
	bt39RTz+6nNfLF2493hQ+9be5Rl+yxefdG1+8PRX4cSDf7MPOXzbZc/38K8Su9Ji8SXue+/l
	dK5ZuvTR1odBfAuc7r2UE+C+GN/hG/fQQ02ledOhJfKv307nmbz8g9suDmeWd5t7/hUpsRRn
	JBpqMRcVJwIAIl1W9g0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 07, 2012 3:25 AM Bryan Wu wrote
> 
> On Tue, Oct 30, 2012 at 2:45 PM, Marek Belisko
> <marek.belisko@open-nandra.com> wrote:
> > Support added only for leds (not for gpio's).
> >
> > Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> > ---
> >  drivers/leds/leds-tca6507.c |   73 +++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 70 insertions(+), 3 deletions(-)
> >
> 
> Overall, this looks good to me. Maybe some question as below,
> 
> -Bryan
> 
> > diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> > index dabcf7a..496dd98 100644
> > --- a/drivers/leds/leds-tca6507.c
> > +++ b/drivers/leds/leds-tca6507.c
> > @@ -667,6 +667,69 @@ static void tca6507_remove_gpio(struct tca6507_chip *tca)
> >  }
> >  #endif /* CONFIG_GPIOLIB */
> >
> > +#ifdef CONFIG_OF
> > +static struct tca6507_platform_data * __devinit tca6507_led_dt_init(struct i2c_client *client)
> > +{
> > +       struct device_node *np = client->dev.of_node, *child;
> > +       struct tca6507_platform_data *pdata;
> > +       struct led_info *tca_leds;
> > +       int count = 0;
> > +
> > +       for_each_child_of_node(np, child)
> > +               count++;
> > +       if (!count)
> > +               return NULL;
> > +
> 
> I saw many 'return NULL' here, why not return some error code in ERR_PTR?
> 
> > +       if (count > NUM_LEDS)
> > +               return NULL;
> > +
> > +       tca_leds = devm_kzalloc(&client->dev, sizeof(struct led_info) * NUM_LEDS, GFP_KERNEL);
> > +
> 
> useless empty line.
> 
> > +       if (!tca_leds)
> > +               return NULL;
> > +
> > +
> 
> useless empty line.
> 
> > +       for_each_child_of_node(np, child) {
> > +               struct led_info led;
> > +               u32 reg;
> > +               int ret;
> > +
> > +               led.name = of_get_property(child, "label", NULL) ? : child->name;
> > +               led.default_trigger =
> > +                       of_get_property(child, "linux,default-trigger", NULL);
> > +
> > +               ret = of_property_read_u32(child, "reg", &reg);
> > +
> > +               if (ret != 0)
> > +                       continue;
> > +               tca_leds[reg] = led;
> > +       }
> > +       pdata = devm_kzalloc(&client->dev, sizeof(struct tca6507_platform_data), GFP_KERNEL);
> > +       if (!pdata) {
> > +               kfree(tca_leds);
> 
> Do we need to kfree here? I think devm_zalloc() will take care of this
> if the driver failed to register.

If devm_kzalloc() fails, tca6507_probe() will return '-ENODEV'.
In this case, kfree() is unnecessary in this case, when devm_kzalloc()
is used.

Moreover, even if kfree() is necessary, devm_kfree() should be used
instead of kfree().

Marek Belisko, please refer to this document.
: http://www.kernel.org/doc/htmldocs/device-drivers/API-devm-kzalloc.html

Thank you.


Best regards,
Jingoo Han


> 
> > +               return NULL;
> > +       }
> > +
> > +       pdata->leds.leds = tca_leds;
> > +       pdata->leds.num_leds = NUM_LEDS;
> > +
> > +       return pdata;
> > +}
> > +
> > +static const struct of_device_id of_tca6507_leds_match[] = {
> > +       { .compatible = "leds-tca6507", },
> > +       {},
> > +};
> > +
> > +#else
> > +static int __devinit tca6507_led_dt_init(struct i2c_client *client, struct tca6507_platform_data
> *data)
> > +{
> > +       return -1;
> > +}
> > +
> > +#define of_tca6507_leds_match NULL
> > +#endif
> > +
> >  static int __devinit tca6507_probe(struct i2c_client *client,
> >                                    const struct i2c_device_id *id)
> >  {
> > @@ -683,9 +746,12 @@ static int __devinit tca6507_probe(struct i2c_client *client,
> >                 return -EIO;
> >
> >         if (!pdata || pdata->leds.num_leds != NUM_LEDS) {
> > -               dev_err(&client->dev, "Need %d entries in platform-data list\n",
> > -                       NUM_LEDS);
> > -               return -ENODEV;
> > +               pdata = tca6507_led_dt_init(client);
> > +               if (!pdata) {
> > +                       dev_err(&client->dev, "Need %d entries in platform-data list\n",
> > +                               NUM_LEDS);
> > +                       return -ENODEV;
> > +               }
> >         }
> >         tca = devm_kzalloc(&client->dev, sizeof(*tca), GFP_KERNEL);
> >         if (!tca)
> > @@ -750,6 +816,7 @@ static struct i2c_driver tca6507_driver = {
> >         .driver   = {
> >                 .name    = "leds-tca6507",
> >                 .owner   = THIS_MODULE,
> > +               .of_match_table = of_tca6507_leds_match,
> >         },
> >         .probe    = tca6507_probe,
> >         .remove   = __devexit_p(tca6507_remove),
> > --
> > 1.7.9.5
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


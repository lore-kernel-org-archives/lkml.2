Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1ANAKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:10:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41226 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1ANAKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:10:00 -0500
Date: Fri, 14 Jan 2011 11:09:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build warnings in Linus' tree
Message-Id: <20110114110952.bb7d6f37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Jan_2011_11_09_52_+1100_5OgaBDCfmnT4ehMx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Jan_2011_11_09_52_+1100_5OgaBDCfmnT4ehMx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

[This is deliberately long ...]

While building Linus' tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/i2c/muxes/gpio-i2cmux.c: In function 'gpiomux_probe':
drivers/i2c/muxes/gpio-i2cmux.c:101: warning: ignoring return value of 'gpi=
o_direction_output', declared with attribute warn_unused_result
drivers/leds/leds-bd2802.c: In function 'bd2802_probe':
drivers/leds/leds-bd2802.c:700: warning: ignoring return value of 'gpio_req=
uest', declared with attribute warn_unused_result
drivers/leds/leds-bd2802.c:701: warning: ignoring return value of 'gpio_dir=
ection_output', declared with attribute warn_unused_result
drivers/input/mouse/gpio_mouse.c: In function 'gpio_mouse_probe':
drivers/input/mouse/gpio_mouse.c:93: warning: ignoring return value of 'gpi=
o_direction_input', declared with attribute warn_unused_result
sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_probe':
sound/soc/codecs/tlv320aic3x.c:1385: warning: ignoring return value of 'gpi=
o_direction_output', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c: In function 'i2c_gpio_setsda_dir':
drivers/i2c/busses/i2c-gpio.c:26: warning: ignoring return value of 'gpio_d=
irection_input', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c:28: warning: ignoring return value of 'gpio_d=
irection_output', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c: In function 'i2c_gpio_setscl_dir':
drivers/i2c/busses/i2c-gpio.c:49: warning: ignoring return value of 'gpio_d=
irection_input', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c:51: warning: ignoring return value of 'gpio_d=
irection_output', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c: In function 'i2c_gpio_probe':
drivers/i2c/busses/i2c-gpio.c:108: warning: ignoring return value of 'gpio_=
direction_output', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c:111: warning: ignoring return value of 'gpio_=
direction_input', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c:116: warning: ignoring return value of 'gpio_=
direction_output', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-gpio.c:119: warning: ignoring return value of 'gpio_=
direction_input', declared with attribute warn_unused_result
drivers/input/keyboard/matrix_keypad.c: In function '__activate_col':
drivers/input/keyboard/matrix_keypad.c:54: warning: ignoring return value o=
f 'gpio_direction_output', declared with attribute warn_unused_result
drivers/input/keyboard/matrix_keypad.c:57: warning: ignoring return value o=
f 'gpio_direction_input', declared with attribute warn_unused_result
drivers/input/keyboard/matrix_keypad.c: In function 'init_matrix_gpio':
drivers/input/keyboard/matrix_keypad.c:317: warning: ignoring return value =
of 'gpio_direction_output', declared with attribute warn_unused_result
drivers/input/keyboard/matrix_keypad.c:329: warning: ignoring return value =
of 'gpio_direction_input', declared with attribute warn_unused_result
sound/soc/codecs/tlv320dac33.c: In function 'dac33_i2c_probe':
sound/soc/codecs/tlv320dac33.c:1563: warning: ignoring return value of 'gpi=
o_direction_output', declared with attribute warn_unused_result
drivers/input/touchscreen/cy8ctmg110_ts.c: In function 'cy8ctmg110_power':
drivers/input/touchscreen/cy8ctmg110_ts.c:71: warning: ignoring return valu=
e of 'gpio_direction_output', declared with attribute warn_unused_result
sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_probe':
sound/soc/codecs/tpa6130a2.c:402: warning: ignoring return value of 'gpio_d=
irection_output', declared with attribute warn_unused_result
drivers/i2c/busses/i2c-pca-platform.c: In function 'i2c_pca_pf_probe':
drivers/i2c/busses/i2c-pca-platform.c:216: warning: ignoring return value o=
f 'gpio_direction_output', declared with attribute warn_unused_result
drivers/media/radio/si4713-i2c.c: In function 'si4713_probe':
drivers/media/radio/si4713-i2c.c:2018: warning: ignoring return value of 'g=
pio_direction_output', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_connection_reset':
drivers/hwmon/sht15.c:128: warning: ignoring return value of 'gpio_directio=
n_output', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_transmission_start':
drivers/hwmon/sht15.c:166: warning: ignoring return value of 'gpio_directio=
n_output', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_wait_for_response':
drivers/hwmon/sht15.c:202: warning: ignoring return value of 'gpio_directio=
n_input', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_update_single_val':
drivers/hwmon/sht15.c:248: warning: ignoring return value of 'gpio_directio=
n_input', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_ack':
drivers/hwmon/sht15.c:414: warning: ignoring return value of 'gpio_directio=
n_output', declared with attribute warn_unused_result
drivers/hwmon/sht15.c:422: warning: ignoring return value of 'gpio_directio=
n_input', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_end_transmission':
drivers/hwmon/sht15.c:432: warning: ignoring return value of 'gpio_directio=
n_output', declared with attribute warn_unused_result
drivers/hwmon/sht15.c: In function 'sht15_probe':
drivers/hwmon/sht15.c:563: warning: ignoring return value of 'gpio_directio=
n_output', declared with attribute warn_unused_result
drivers/regulator/max8952.c: In function 'max8952_pmic_probe':
drivers/regulator/max8952.c:228: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/regulator/max8952.c:246: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/regulator/max8952.c:252: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/rtc/rtc-v3020.c: In function 'v3020_gpio_map':
drivers/rtc/rtc-v3020.c:132: warning: ignoring return value of 'gpio_direct=
ion_output', declared with attribute warn_unused_result
drivers/rtc/rtc-v3020.c: In function 'v3020_gpio_write_bit':
drivers/rtc/rtc-v3020.c:156: warning: ignoring return value of 'gpio_direct=
ion_output', declared with attribute warn_unused_result
drivers/rtc/rtc-v3020.c: In function 'v3020_gpio_read_bit':
drivers/rtc/rtc-v3020.c:168: warning: ignoring return value of 'gpio_direct=
ion_input', declared with attribute warn_unused_result
drivers/usb/otg/gpio_vbus.c: In function 'gpio_vbus_probe':
drivers/usb/otg/gpio_vbus.c:249: warning: ignoring return value of 'gpio_di=
rection_input', declared with attribute warn_unused_result
drivers/usb/otg/gpio_vbus.c:270: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/w1/masters/w1-gpio.c: In function 'w1_gpio_write_bit_dir':
drivers/w1/masters/w1-gpio.c:27: warning: ignoring return value of 'gpio_di=
rection_input', declared with attribute warn_unused_result
drivers/w1/masters/w1-gpio.c:29: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/w1/masters/w1-gpio.c: In function 'w1_gpio_probe':
drivers/w1/masters/w1-gpio.c:67: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/w1/masters/w1-gpio.c:70: warning: ignoring return value of 'gpio_di=
rection_input', declared with attribute warn_unused_result
drivers/net/phy/mdio-gpio.c: In function 'mdio_dir':
drivers/net/phy/mdio-gpio.c:48: warning: ignoring return value of 'gpio_dir=
ection_output', declared with attribute warn_unused_result
drivers/net/phy/mdio-gpio.c:50: warning: ignoring return value of 'gpio_dir=
ection_input', declared with attribute warn_unused_result
drivers/net/phy/mdio-gpio.c: In function 'mdio_gpio_bus_init':
drivers/net/phy/mdio-gpio.c:126: warning: ignoring return value of 'gpio_di=
rection_output', declared with attribute warn_unused_result
drivers/media/video/via-camera.c: In function 'via_sensor_power_setup':
drivers/media/video/via-camera.c:208: warning: ignoring return value of 'gp=
io_direction_output', declared with attribute warn_unused_result
drivers/media/video/via-camera.c:209: warning: ignoring return value of 'gp=
io_direction_output', declared with attribute warn_unused_result
drivers/net/wireless/p54/p54spi.c: In function 'p54spi_probe':
drivers/net/wireless/p54/p54spi.c:641: warning: ignoring return value of 'g=
pio_direction_output', declared with attribute warn_unused_result
drivers/net/wireless/p54/p54spi.c:642: warning: ignoring return value of 'g=
pio_direction_input', declared with attribute warn_unused_result

Introduced by commit 0fdae42d361bbb431ca0ab0efed5126a94821177 ("gpiolib:
annotate gpio-intialization with __must_check").

We used to try to fix most of the bad code *before* introducing these
warnings ... this is just making it much harder to see "real" warnings.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Jan_2011_11_09_52_+1100_5OgaBDCfmnT4ehMx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNL5RQAAoJEDMEi1NhKgbsg/gH/33y96/Hg/wDrU9OpkZmYLds
PJERvjyqnaGXrWwIFXs09KQgGMmnVxKlGv2AwiGZ1aNbHV9EOx+gEvxUoOdgYNPS
0yeRnDYUH/AAhowS5/5JsJh5mv+vSy4napwfQfZCi/afOf2j+9+5qqrW0i5avsgZ
x7rft/mTNEYjMC9509QMAeB/pAIX/ylvLZuH7JeSko/e3tpHd6iBrPJO3T/BdZj/
tn7BmN8yvHl40oVxBYlecQP/R/ss0dH3MDmDcIlFjJVbWYULfhaUroghy5He2Djk
A0vFTaHb87lVqRRVzjtVUvN3k6Kz0VTzjdm0ZhPzLdSWXBGoIVa9CsZ0R9DnrG0=
=qN1C
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Jan_2011_11_09_52_+1100_5OgaBDCfmnT4ehMx--

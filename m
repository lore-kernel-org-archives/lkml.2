Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1KQGs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:48:57 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49812 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1KQGs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:48:56 -0500
Message-ID: <4EC4AE5C.8010000@kernel.org>
Date: Thu, 17 Nov 2011 06:49:00 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 5/5] staging:iio: Use module_spi_driver to register SPI
 driver
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-6-git-send-email-lars@metafoo.de>
In-Reply-To: <1321434819-23678-6-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 09:13 AM, Lars-Peter Clausen wrote:
> Use the newly introduced module_spi_driver macro for registering SPI drivers.
> This allows us to remove a few lines of boilerplate code.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/staging/iio/accel/adis16201_core.c |   13 +------------
>  drivers/staging/iio/accel/adis16203_core.c |   13 +------------
>  drivers/staging/iio/accel/adis16204_core.c |   13 +------------
>  drivers/staging/iio/accel/adis16209_core.c |   13 +------------
>  drivers/staging/iio/accel/adis16220_core.c |   13 +------------
>  drivers/staging/iio/accel/adis16240_core.c |   13 +------------
>  drivers/staging/iio/accel/kxsd9.c          |   13 +------------
>  drivers/staging/iio/accel/lis3l02dq_core.c |   13 +------------
>  drivers/staging/iio/accel/sca3000_core.c   |   13 +------------
>  drivers/staging/iio/adc/ad7192.c           |   13 +------------
>  drivers/staging/iio/adc/ad7280a.c          |   13 +------------
>  drivers/staging/iio/adc/ad7298_core.c      |   13 +------------
>  drivers/staging/iio/adc/ad7476_core.c      |   13 +------------
>  drivers/staging/iio/adc/ad7606_spi.c       |   13 +------------
>  drivers/staging/iio/adc/ad7780.c           |   13 +------------
>  drivers/staging/iio/adc/ad7793.c           |   13 +------------
>  drivers/staging/iio/adc/ad7816.c           |   14 +-------------
>  drivers/staging/iio/adc/ad7887_core.c      |   13 +------------
>  drivers/staging/iio/adc/adt7310.c          |   14 +-------------
>  drivers/staging/iio/addac/adt7316-spi.c    |   14 +-------------
>  drivers/staging/iio/dac/ad5064.c           |   13 +------------
>  drivers/staging/iio/dac/ad5360.c           |   13 +------------
>  drivers/staging/iio/dac/ad5446.c           |   13 +------------
>  drivers/staging/iio/dac/ad5504.c           |   13 +------------
>  drivers/staging/iio/dac/ad5624r_spi.c      |   13 +------------
>  drivers/staging/iio/dac/ad5686.c           |   13 +------------
>  drivers/staging/iio/dac/ad5791.c           |   13 +------------
>  drivers/staging/iio/dds/ad5930.c           |   13 +------------
>  drivers/staging/iio/dds/ad9832.c           |   13 +------------
>  drivers/staging/iio/dds/ad9834.c           |   13 +------------
>  drivers/staging/iio/dds/ad9850.c           |   13 +------------
>  drivers/staging/iio/dds/ad9852.c           |   13 +------------
>  drivers/staging/iio/dds/ad9910.c           |   13 +------------
>  drivers/staging/iio/dds/ad9951.c           |   13 +------------
>  drivers/staging/iio/gyro/adis16080_core.c  |   13 +------------
>  drivers/staging/iio/gyro/adis16130_core.c  |   13 +------------
>  drivers/staging/iio/gyro/adis16260_core.c  |   13 +------------
>  drivers/staging/iio/gyro/adxrs450_core.c   |   13 +------------
>  drivers/staging/iio/imu/adis16400_core.c   |   13 +------------
>  drivers/staging/iio/meter/ade7753.c        |   13 +------------
>  drivers/staging/iio/meter/ade7754.c        |   13 +------------
>  drivers/staging/iio/meter/ade7758_core.c   |   13 +------------
>  drivers/staging/iio/meter/ade7759.c        |   13 +------------
>  drivers/staging/iio/meter/ade7854-spi.c    |   13 +------------
>  drivers/staging/iio/resolver/ad2s1200.c    |   13 +------------
>  drivers/staging/iio/resolver/ad2s1210.c    |   13 +------------
>  drivers/staging/iio/resolver/ad2s90.c      |   13 +------------
>  47 files changed, 47 insertions(+), 567 deletions(-)
> 
> diff --git a/drivers/staging/iio/accel/adis16201_core.c b/drivers/staging/iio/accel/adis16201_core.c
> index 1c5dad5..97f747e 100644
> --- a/drivers/staging/iio/accel/adis16201_core.c
> +++ b/drivers/staging/iio/accel/adis16201_core.c
> @@ -549,18 +549,7 @@ static struct spi_driver adis16201_driver = {
>  	.probe = adis16201_probe,
>  	.remove = __devexit_p(adis16201_remove),
>  };
> -
> -static __init int adis16201_init(void)
> -{
> -	return spi_register_driver(&adis16201_driver);
> -}
> -module_init(adis16201_init);
> -
> -static __exit void adis16201_exit(void)
> -{
> -	spi_unregister_driver(&adis16201_driver);
> -}
> -module_exit(adis16201_exit);
> +module_spi_driver(adis16201_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16201 Programmable Digital Vibration Sensor driver");
> diff --git a/drivers/staging/iio/accel/adis16203_core.c b/drivers/staging/iio/accel/adis16203_core.c
> index 8a33374..a6d6d27 100644
> --- a/drivers/staging/iio/accel/adis16203_core.c
> +++ b/drivers/staging/iio/accel/adis16203_core.c
> @@ -504,18 +504,7 @@ static struct spi_driver adis16203_driver = {
>  	.probe = adis16203_probe,
>  	.remove = __devexit_p(adis16203_remove),
>  };
> -
> -static __init int adis16203_init(void)
> -{
> -	return spi_register_driver(&adis16203_driver);
> -}
> -module_init(adis16203_init);
> -
> -static __exit void adis16203_exit(void)
> -{
> -	spi_unregister_driver(&adis16203_driver);
> -}
> -module_exit(adis16203_exit);
> +module_spi_driver(adis16203_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16203 Programmable Digital Vibration Sensor driver");
> diff --git a/drivers/staging/iio/accel/adis16204_core.c b/drivers/staging/iio/accel/adis16204_core.c
> index 644ac8e..7ac5b4c 100644
> --- a/drivers/staging/iio/accel/adis16204_core.c
> +++ b/drivers/staging/iio/accel/adis16204_core.c
> @@ -577,18 +577,7 @@ static struct spi_driver adis16204_driver = {
>  	.probe = adis16204_probe,
>  	.remove = __devexit_p(adis16204_remove),
>  };
> -
> -static __init int adis16204_init(void)
> -{
> -	return spi_register_driver(&adis16204_driver);
> -}
> -module_init(adis16204_init);
> -
> -static __exit void adis16204_exit(void)
> -{
> -	spi_unregister_driver(&adis16204_driver);
> -}
> -module_exit(adis16204_exit);
> +module_spi_driver(adis16204_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("ADIS16204 High-g Digital Impact Sensor and Recorder");
> diff --git a/drivers/staging/iio/accel/adis16209_core.c b/drivers/staging/iio/accel/adis16209_core.c
> index 0a8571b..c03afbf 100644
> --- a/drivers/staging/iio/accel/adis16209_core.c
> +++ b/drivers/staging/iio/accel/adis16209_core.c
> @@ -553,18 +553,7 @@ static struct spi_driver adis16209_driver = {
>  	.probe = adis16209_probe,
>  	.remove = __devexit_p(adis16209_remove),
>  };
> -
> -static __init int adis16209_init(void)
> -{
> -	return spi_register_driver(&adis16209_driver);
> -}
> -module_init(adis16209_init);
> -
> -static __exit void adis16209_exit(void)
> -{
> -	spi_unregister_driver(&adis16209_driver);
> -}
> -module_exit(adis16209_exit);
> +module_spi_driver(adis16209_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16209 Digital Vibration Sensor driver");
> diff --git a/drivers/staging/iio/accel/adis16220_core.c b/drivers/staging/iio/accel/adis16220_core.c
> index 6d4503d..73298e7 100644
> --- a/drivers/staging/iio/accel/adis16220_core.c
> +++ b/drivers/staging/iio/accel/adis16220_core.c
> @@ -708,18 +708,7 @@ static struct spi_driver adis16220_driver = {
>  	.probe = adis16220_probe,
>  	.remove = __devexit_p(adis16220_remove),
>  };
> -
> -static __init int adis16220_init(void)
> -{
> -	return spi_register_driver(&adis16220_driver);
> -}
> -module_init(adis16220_init);
> -
> -static __exit void adis16220_exit(void)
> -{
> -	spi_unregister_driver(&adis16220_driver);
> -}
> -module_exit(adis16220_exit);
> +module_spi_driver(adis16220_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16220 Digital Vibration Sensor");
> diff --git a/drivers/staging/iio/accel/adis16240_core.c b/drivers/staging/iio/accel/adis16240_core.c
> index b8be292..88881b9 100644
> --- a/drivers/staging/iio/accel/adis16240_core.c
> +++ b/drivers/staging/iio/accel/adis16240_core.c
> @@ -606,18 +606,7 @@ static struct spi_driver adis16240_driver = {
>  	.probe = adis16240_probe,
>  	.remove = __devexit_p(adis16240_remove),
>  };
> -
> -static __init int adis16240_init(void)
> -{
> -	return spi_register_driver(&adis16240_driver);
> -}
> -module_init(adis16240_init);
> -
> -static __exit void adis16240_exit(void)
> -{
> -	spi_unregister_driver(&adis16240_driver);
> -}
> -module_exit(adis16240_exit);
> +module_spi_driver(adis16240_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices Programmable Impact Sensor and Recorder");
> diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
> index 5238503..cfce21c 100644
> --- a/drivers/staging/iio/accel/kxsd9.c
> +++ b/drivers/staging/iio/accel/kxsd9.c
> @@ -280,18 +280,7 @@ static struct spi_driver kxsd9_driver = {
>  	.remove = __devexit_p(kxsd9_remove),
>  	.id_table = kxsd9_id,
>  };
> -
> -static __init int kxsd9_spi_init(void)
> -{
> -	return spi_register_driver(&kxsd9_driver);
> -}
> -module_init(kxsd9_spi_init);
> -
> -static __exit void kxsd9_spi_exit(void)
> -{
> -	spi_unregister_driver(&kxsd9_driver);
> -}
> -module_exit(kxsd9_spi_exit);
> +module_spi_driver(kxsd9_driver);
>  
>  MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
>  MODULE_DESCRIPTION("Kionix KXSD9 SPI driver");
> diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
> index 559545a..6877521 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_core.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_core.c
> @@ -804,18 +804,7 @@ static struct spi_driver lis3l02dq_driver = {
>  	.probe = lis3l02dq_probe,
>  	.remove = __devexit_p(lis3l02dq_remove),
>  };
> -
> -static __init int lis3l02dq_init(void)
> -{
> -	return spi_register_driver(&lis3l02dq_driver);
> -}
> -module_init(lis3l02dq_init);
> -
> -static __exit void lis3l02dq_exit(void)
> -{
> -	spi_unregister_driver(&lis3l02dq_driver);
> -}
> -module_exit(lis3l02dq_exit);
> +module_spi_driver(lis3l02dq_driver);
>  
>  MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
>  MODULE_DESCRIPTION("ST LIS3L02DQ Accelerometer SPI driver");
> diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
> index a44a705..6c35907 100644
> --- a/drivers/staging/iio/accel/sca3000_core.c
> +++ b/drivers/staging/iio/accel/sca3000_core.c
> @@ -1250,18 +1250,7 @@ static struct spi_driver sca3000_driver = {
>  	.remove = __devexit_p(sca3000_remove),
>  	.id_table = sca3000_id,
>  };
> -
> -static __init int sca3000_init(void)
> -{
> -	return spi_register_driver(&sca3000_driver);
> -}
> -module_init(sca3000_init);
> -
> -static __exit void sca3000_exit(void)
> -{
> -	spi_unregister_driver(&sca3000_driver);
> -}
> -module_exit(sca3000_exit);
> +module_spi_driver(sca3000_driver);
>  
>  MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
>  MODULE_DESCRIPTION("VTI SCA3000 Series Accelerometers SPI driver");
> diff --git a/drivers/staging/iio/adc/ad7192.c b/drivers/staging/iio/adc/ad7192.c
> index 31c376b..a6a4a4e 100644
> --- a/drivers/staging/iio/adc/ad7192.c
> +++ b/drivers/staging/iio/adc/ad7192.c
> @@ -1161,18 +1161,7 @@ static struct spi_driver ad7192_driver = {
>  	.remove		= __devexit_p(ad7192_remove),
>  	.id_table	= ad7192_id,
>  };
> -
> -static int __init ad7192_init(void)
> -{
> -	return spi_register_driver(&ad7192_driver);
> -}
> -module_init(ad7192_init);
> -
> -static void __exit ad7192_exit(void)
> -{
> -	spi_unregister_driver(&ad7192_driver);
> -}
> -module_exit(ad7192_exit);
> +module_spi_driver(ad7192_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7190, AD7192, AD7195 ADC");
> diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
> index 372d059..dbaeae8 100644
> --- a/drivers/staging/iio/adc/ad7280a.c
> +++ b/drivers/staging/iio/adc/ad7280a.c
> @@ -979,18 +979,7 @@ static struct spi_driver ad7280_driver = {
>  	.remove		= __devexit_p(ad7280_remove),
>  	.id_table	= ad7280_id,
>  };
> -
> -static int __init ad7280_init(void)
> -{
> -	return spi_register_driver(&ad7280_driver);
> -}
> -module_init(ad7280_init);
> -
> -static void __exit ad7280_exit(void)
> -{
> -	spi_unregister_driver(&ad7280_driver);
> -}
> -module_exit(ad7280_exit);
> +module_spi_driver(ad7280_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7280A");
> diff --git a/drivers/staging/iio/adc/ad7298_core.c b/drivers/staging/iio/adc/ad7298_core.c
> index c1de73a..a799bd1 100644
> --- a/drivers/staging/iio/adc/ad7298_core.c
> +++ b/drivers/staging/iio/adc/ad7298_core.c
> @@ -276,18 +276,7 @@ static struct spi_driver ad7298_driver = {
>  	.remove		= __devexit_p(ad7298_remove),
>  	.id_table	= ad7298_id,
>  };
> -
> -static int __init ad7298_init(void)
> -{
> -	return spi_register_driver(&ad7298_driver);
> -}
> -module_init(ad7298_init);
> -
> -static void __exit ad7298_exit(void)
> -{
> -	spi_unregister_driver(&ad7298_driver);
> -}
> -module_exit(ad7298_exit);
> +module_spi_driver(ad7298_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7298 ADC");
> diff --git a/drivers/staging/iio/adc/ad7476_core.c b/drivers/staging/iio/adc/ad7476_core.c
> index fd79fac..0b58520 100644
> --- a/drivers/staging/iio/adc/ad7476_core.c
> +++ b/drivers/staging/iio/adc/ad7476_core.c
> @@ -248,18 +248,7 @@ static struct spi_driver ad7476_driver = {
>  	.remove		= __devexit_p(ad7476_remove),
>  	.id_table	= ad7476_id,
>  };
> -
> -static int __init ad7476_init(void)
> -{
> -	return spi_register_driver(&ad7476_driver);
> -}
> -module_init(ad7476_init);
> -
> -static void __exit ad7476_exit(void)
> -{
> -	spi_unregister_driver(&ad7476_driver);
> -}
> -module_exit(ad7476_exit);
> +module_spi_driver(ad7476_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7475/6/7/8(A) AD7466/7/8 ADC");
> diff --git a/drivers/staging/iio/adc/ad7606_spi.c b/drivers/staging/iio/adc/ad7606_spi.c
> index aede1ba..b984bd2 100644
> --- a/drivers/staging/iio/adc/ad7606_spi.c
> +++ b/drivers/staging/iio/adc/ad7606_spi.c
> @@ -109,18 +109,7 @@ static struct spi_driver ad7606_driver = {
>  	.remove = __devexit_p(ad7606_spi_remove),
>  	.id_table = ad7606_id,
>  };
> -
> -static int __init ad7606_spi_init(void)
> -{
> -	return spi_register_driver(&ad7606_driver);
> -}
> -module_init(ad7606_spi_init);
> -
> -static void __exit ad7606_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad7606_driver);
> -}
> -module_exit(ad7606_spi_exit);
> +module_spi_driver(ad7606_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7606 ADC");
> diff --git a/drivers/staging/iio/adc/ad7780.c b/drivers/staging/iio/adc/ad7780.c
> index 7a579a1..ec90261 100644
> --- a/drivers/staging/iio/adc/ad7780.c
> +++ b/drivers/staging/iio/adc/ad7780.c
> @@ -283,18 +283,7 @@ static struct spi_driver ad7780_driver = {
>  	.remove		= __devexit_p(ad7780_remove),
>  	.id_table	= ad7780_id,
>  };
> -
> -static int __init ad7780_init(void)
> -{
> -	return spi_register_driver(&ad7780_driver);
> -}
> -module_init(ad7780_init);
> -
> -static void __exit ad7780_exit(void)
> -{
> -	spi_unregister_driver(&ad7780_driver);
> -}
> -module_exit(ad7780_exit);
> +module_spi_driver(ad7780_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7780/1 ADC");
> diff --git a/drivers/staging/iio/adc/ad7793.c b/drivers/staging/iio/adc/ad7793.c
> index 999f8f7..1c5588e 100644
> --- a/drivers/staging/iio/adc/ad7793.c
> +++ b/drivers/staging/iio/adc/ad7793.c
> @@ -1045,18 +1045,7 @@ static struct spi_driver ad7793_driver = {
>  	.remove		= __devexit_p(ad7793_remove),
>  	.id_table	= ad7793_id,
>  };
> -
> -static int __init ad7793_init(void)
> -{
> -	return spi_register_driver(&ad7793_driver);
> -}
> -module_init(ad7793_init);
> -
> -static void __exit ad7793_exit(void)
> -{
> -	spi_unregister_driver(&ad7793_driver);
> -}
> -module_exit(ad7793_exit);
> +module_spi_driver(ad7793_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7792/3 ADC");
> diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
> index bdb9049..acbf936 100644
> --- a/drivers/staging/iio/adc/ad7816.c
> +++ b/drivers/staging/iio/adc/ad7816.c
> @@ -466,21 +466,9 @@ static struct spi_driver ad7816_driver = {
>  	.remove = __devexit_p(ad7816_remove),
>  	.id_table = ad7816_id,
>  };
> -
> -static __init int ad7816_init(void)
> -{
> -	return spi_register_driver(&ad7816_driver);
> -}
> -
> -static __exit void ad7816_exit(void)
> -{
> -	spi_unregister_driver(&ad7816_driver);
> -}
> +module_spi_driver(ad7816_driver);
>  
>  MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
>  MODULE_DESCRIPTION("Analog Devices AD7816/7/8 digital"
>  			" temperature sensor driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(ad7816_init);
> -module_exit(ad7816_exit);
> diff --git a/drivers/staging/iio/adc/ad7887_core.c b/drivers/staging/iio/adc/ad7887_core.c
> index 609dcd5..91b8fb0 100644
> --- a/drivers/staging/iio/adc/ad7887_core.c
> +++ b/drivers/staging/iio/adc/ad7887_core.c
> @@ -257,18 +257,7 @@ static struct spi_driver ad7887_driver = {
>  	.remove		= __devexit_p(ad7887_remove),
>  	.id_table	= ad7887_id,
>  };
> -
> -static int __init ad7887_init(void)
> -{
> -	return spi_register_driver(&ad7887_driver);
> -}
> -module_init(ad7887_init);
> -
> -static void __exit ad7887_exit(void)
> -{
> -	spi_unregister_driver(&ad7887_driver);
> -}
> -module_exit(ad7887_exit);
> +module_spi_driver(ad7887_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD7887 ADC");
> diff --git a/drivers/staging/iio/adc/adt7310.c b/drivers/staging/iio/adc/adt7310.c
> index c9e0be3..bc307f3 100644
> --- a/drivers/staging/iio/adc/adt7310.c
> +++ b/drivers/staging/iio/adc/adt7310.c
> @@ -884,21 +884,9 @@ static struct spi_driver adt7310_driver = {
>  	.remove = __devexit_p(adt7310_remove),
>  	.id_table = adt7310_id,
>  };
> -
> -static __init int adt7310_init(void)
> -{
> -	return spi_register_driver(&adt7310_driver);
> -}
> -
> -static __exit void adt7310_exit(void)
> -{
> -	spi_unregister_driver(&adt7310_driver);
> -}
> +module_spi_driver(adt7310_driver);
>  
>  MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
>  MODULE_DESCRIPTION("Analog Devices ADT7310 digital"
>  			" temperature sensor driver");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(adt7310_init);
> -module_exit(adt7310_exit);
> diff --git a/drivers/staging/iio/addac/adt7316-spi.c b/drivers/staging/iio/addac/adt7316-spi.c
> index 369d4d0..1e93c7b 100644
> --- a/drivers/staging/iio/addac/adt7316-spi.c
> +++ b/drivers/staging/iio/addac/adt7316-spi.c
> @@ -160,21 +160,9 @@ static struct spi_driver adt7316_driver = {
>  	.resume = adt7316_spi_resume,
>  	.id_table = adt7316_spi_id,
>  };
> -
> -static __init int adt7316_spi_init(void)
> -{
> -	return spi_register_driver(&adt7316_driver);
> -}
> -
> -static __exit void adt7316_spi_exit(void)
> -{
> -	spi_unregister_driver(&adt7316_driver);
> -}
> +module_spi_driver(adt7316_driver);
>  
>  MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
>  MODULE_DESCRIPTION("SPI bus driver for Analog Devices ADT7316/7/8 and"
>  			"ADT7516/7/9 digital temperature sensor, ADC and DAC");
>  MODULE_LICENSE("GPL v2");
> -
> -module_init(adt7316_spi_init);
> -module_exit(adt7316_spi_exit);
> diff --git a/drivers/staging/iio/dac/ad5064.c b/drivers/staging/iio/dac/ad5064.c
> index 24279f2..39cfe6c 100644
> --- a/drivers/staging/iio/dac/ad5064.c
> +++ b/drivers/staging/iio/dac/ad5064.c
> @@ -445,18 +445,7 @@ static struct spi_driver ad5064_driver = {
>  	.remove = __devexit_p(ad5064_remove),
>  	.id_table = ad5064_id,
>  };
> -
> -static __init int ad5064_spi_init(void)
> -{
> -	return spi_register_driver(&ad5064_driver);
> -}
> -module_init(ad5064_spi_init);
> -
> -static __exit void ad5064_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5064_driver);
> -}
> -module_exit(ad5064_spi_exit);
> +module_spi_driver(ad5064_driver);
>  
>  MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>  MODULE_DESCRIPTION("Analog Devices AD5064/64-1/44/24 DAC");
> diff --git a/drivers/staging/iio/dac/ad5360.c b/drivers/staging/iio/dac/ad5360.c
> index 72d0f3f0..bc0459e 100644
> --- a/drivers/staging/iio/dac/ad5360.c
> +++ b/drivers/staging/iio/dac/ad5360.c
> @@ -563,18 +563,7 @@ static struct spi_driver ad5360_driver = {
>  	.remove = __devexit_p(ad5360_remove),
>  	.id_table = ad5360_ids,
>  };
> -
> -static __init int ad5360_spi_init(void)
> -{
> -	return spi_register_driver(&ad5360_driver);
> -}
> -module_init(ad5360_spi_init);
> -
> -static __exit void ad5360_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5360_driver);
> -}
> -module_exit(ad5360_spi_exit);
> +module_spi_driver(ad5360_driver);
>  
>  MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>  MODULE_DESCRIPTION("Analog Devices AD5360/61/62/63/70/71/72/73 DAC");
> diff --git a/drivers/staging/iio/dac/ad5446.c b/drivers/staging/iio/dac/ad5446.c
> index e1c204d..ac3bc5f 100644
> --- a/drivers/staging/iio/dac/ad5446.c
> +++ b/drivers/staging/iio/dac/ad5446.c
> @@ -465,18 +465,7 @@ static struct spi_driver ad5446_driver = {
>  	.remove		= __devexit_p(ad5446_remove),
>  	.id_table	= ad5446_id,
>  };
> -
> -static int __init ad5446_init(void)
> -{
> -	return spi_register_driver(&ad5446_driver);
> -}
> -module_init(ad5446_init);
> -
> -static void __exit ad5446_exit(void)
> -{
> -	spi_unregister_driver(&ad5446_driver);
> -}
> -module_exit(ad5446_exit);
> +module_spi_driver(ad5446_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD5444/AD5446 DAC");
> diff --git a/drivers/staging/iio/dac/ad5504.c b/drivers/staging/iio/dac/ad5504.c
> index 60dd640..57539ce 100644
> --- a/drivers/staging/iio/dac/ad5504.c
> +++ b/drivers/staging/iio/dac/ad5504.c
> @@ -377,18 +377,7 @@ static struct spi_driver ad5504_driver = {
>  	.remove = __devexit_p(ad5504_remove),
>  	.id_table = ad5504_id,
>  };
> -
> -static __init int ad5504_spi_init(void)
> -{
> -	return spi_register_driver(&ad5504_driver);
> -}
> -module_init(ad5504_spi_init);
> -
> -static __exit void ad5504_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5504_driver);
> -}
> -module_exit(ad5504_spi_exit);
> +module_spi_driver(ad5504_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD5501/AD5501 DAC");
> diff --git a/drivers/staging/iio/dac/ad5624r_spi.c b/drivers/staging/iio/dac/ad5624r_spi.c
> index 284d879..6e05f0d 100644
> --- a/drivers/staging/iio/dac/ad5624r_spi.c
> +++ b/drivers/staging/iio/dac/ad5624r_spi.c
> @@ -317,18 +317,7 @@ static struct spi_driver ad5624r_driver = {
>  	.remove = __devexit_p(ad5624r_remove),
>  	.id_table = ad5624r_id,
>  };
> -
> -static __init int ad5624r_spi_init(void)
> -{
> -	return spi_register_driver(&ad5624r_driver);
> -}
> -module_init(ad5624r_spi_init);
> -
> -static __exit void ad5624r_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5624r_driver);
> -}
> -module_exit(ad5624r_spi_exit);
> +module_spi_driver(ad5624r_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices AD5624/44/64R DAC spi driver");
> diff --git a/drivers/staging/iio/dac/ad5686.c b/drivers/staging/iio/dac/ad5686.c
> index 974c6f5..e72db2f 100644
> --- a/drivers/staging/iio/dac/ad5686.c
> +++ b/drivers/staging/iio/dac/ad5686.c
> @@ -447,18 +447,7 @@ static struct spi_driver ad5686_driver = {
>  	.remove = __devexit_p(ad5686_remove),
>  	.id_table = ad5686_id,
>  };
> -
> -static __init int ad5686_spi_init(void)
> -{
> -	return spi_register_driver(&ad5686_driver);
> -}
> -module_init(ad5686_spi_init);
> -
> -static __exit void ad5686_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5686_driver);
> -}
> -module_exit(ad5686_spi_exit);
> +module_spi_driver(ad5686_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD5686/85/84 DAC");
> diff --git a/drivers/staging/iio/dac/ad5791.c b/drivers/staging/iio/dac/ad5791.c
> index 6fbca8d..4a80fd8 100644
> --- a/drivers/staging/iio/dac/ad5791.c
> +++ b/drivers/staging/iio/dac/ad5791.c
> @@ -410,18 +410,7 @@ static struct spi_driver ad5791_driver = {
>  	.remove = __devexit_p(ad5791_remove),
>  	.id_table = ad5791_id,
>  };
> -
> -static __init int ad5791_spi_init(void)
> -{
> -	return spi_register_driver(&ad5791_driver);
> -}
> -module_init(ad5791_spi_init);
> -
> -static __exit void ad5791_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5791_driver);
> -}
> -module_exit(ad5791_spi_exit);
> +module_spi_driver(ad5791_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD5760/AD5780/AD5781/AD5791 DAC");
> diff --git a/drivers/staging/iio/dds/ad5930.c b/drivers/staging/iio/dds/ad5930.c
> index f5e368b..4a360d0 100644
> --- a/drivers/staging/iio/dds/ad5930.c
> +++ b/drivers/staging/iio/dds/ad5930.c
> @@ -143,18 +143,7 @@ static struct spi_driver ad5930_driver = {
>  	.probe = ad5930_probe,
>  	.remove = __devexit_p(ad5930_remove),
>  };
> -
> -static __init int ad5930_spi_init(void)
> -{
> -	return spi_register_driver(&ad5930_driver);
> -}
> -module_init(ad5930_spi_init);
> -
> -static __exit void ad5930_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad5930_driver);
> -}
> -module_exit(ad5930_spi_exit);
> +module_spi_driver(ad5930_driver);
>  
>  MODULE_AUTHOR("Cliff Cai");
>  MODULE_DESCRIPTION("Analog Devices ad5930 driver");
> diff --git a/drivers/staging/iio/dds/ad9832.c b/drivers/staging/iio/dds/ad9832.c
> index 9b4ff60..cc32fd6 100644
> --- a/drivers/staging/iio/dds/ad9832.c
> +++ b/drivers/staging/iio/dds/ad9832.c
> @@ -355,18 +355,7 @@ static struct spi_driver ad9832_driver = {
>  	.remove		= __devexit_p(ad9832_remove),
>  	.id_table	= ad9832_id,
>  };
> -
> -static int __init ad9832_init(void)
> -{
> -	return spi_register_driver(&ad9832_driver);
> -}
> -module_init(ad9832_init);
> -
> -static void __exit ad9832_exit(void)
> -{
> -	spi_unregister_driver(&ad9832_driver);
> -}
> -module_exit(ad9832_exit);
> +module_spi_driver(ad9832_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD9832/AD9835 DDS");
> diff --git a/drivers/staging/iio/dds/ad9834.c b/drivers/staging/iio/dds/ad9834.c
> index c468f69..2b31e35 100644
> --- a/drivers/staging/iio/dds/ad9834.c
> +++ b/drivers/staging/iio/dds/ad9834.c
> @@ -446,18 +446,7 @@ static struct spi_driver ad9834_driver = {
>  	.remove		= __devexit_p(ad9834_remove),
>  	.id_table	= ad9834_id,
>  };
> -
> -static int __init ad9834_init(void)
> -{
> -	return spi_register_driver(&ad9834_driver);
> -}
> -module_init(ad9834_init);
> -
> -static void __exit ad9834_exit(void)
> -{
> -	spi_unregister_driver(&ad9834_driver);
> -}
> -module_exit(ad9834_exit);
> +module_spi_driver(ad9834_driver);
>  
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("Analog Devices AD9833/AD9834/AD9837/AD9838 DDS");
> diff --git a/drivers/staging/iio/dds/ad9850.c b/drivers/staging/iio/dds/ad9850.c
> index a14771b..f9c96af 100644
> --- a/drivers/staging/iio/dds/ad9850.c
> +++ b/drivers/staging/iio/dds/ad9850.c
> @@ -129,18 +129,7 @@ static struct spi_driver ad9850_driver = {
>  	.probe = ad9850_probe,
>  	.remove = __devexit_p(ad9850_remove),
>  };
> -
> -static __init int ad9850_spi_init(void)
> -{
> -	return spi_register_driver(&ad9850_driver);
> -}
> -module_init(ad9850_spi_init);
> -
> -static __exit void ad9850_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad9850_driver);
> -}
> -module_exit(ad9850_spi_exit);
> +module_spi_driver(ad9850_driver);
>  
>  MODULE_AUTHOR("Cliff Cai");
>  MODULE_DESCRIPTION("Analog Devices ad9850 driver");
> diff --git a/drivers/staging/iio/dds/ad9852.c b/drivers/staging/iio/dds/ad9852.c
> index cfceaa6..9fc73fd 100644
> --- a/drivers/staging/iio/dds/ad9852.c
> +++ b/drivers/staging/iio/dds/ad9852.c
> @@ -280,18 +280,7 @@ static struct spi_driver ad9852_driver = {
>  	.probe = ad9852_probe,
>  	.remove = __devexit_p(ad9852_remove),
>  };
> -
> -static __init int ad9852_spi_init(void)
> -{
> -	return spi_register_driver(&ad9852_driver);
> -}
> -module_init(ad9852_spi_init);
> -
> -static __exit void ad9852_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad9852_driver);
> -}
> -module_exit(ad9852_spi_exit);
> +module_spi_driver(ad9852_driver);
>  
>  MODULE_AUTHOR("Cliff Cai");
>  MODULE_DESCRIPTION("Analog Devices ad9852 driver");
> diff --git a/drivers/staging/iio/dds/ad9910.c b/drivers/staging/iio/dds/ad9910.c
> index da83d2b..57046b0 100644
> --- a/drivers/staging/iio/dds/ad9910.c
> +++ b/drivers/staging/iio/dds/ad9910.c
> @@ -413,18 +413,7 @@ static struct spi_driver ad9910_driver = {
>  	.probe = ad9910_probe,
>  	.remove = __devexit_p(ad9910_remove),
>  };
> -
> -static __init int ad9910_spi_init(void)
> -{
> -	return spi_register_driver(&ad9910_driver);
> -}
> -module_init(ad9910_spi_init);
> -
> -static __exit void ad9910_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad9910_driver);
> -}
> -module_exit(ad9910_spi_exit);
> +module_spi_driver(ad9910_driver);
>  
>  MODULE_AUTHOR("Cliff Cai");
>  MODULE_DESCRIPTION("Analog Devices ad9910 driver");
> diff --git a/drivers/staging/iio/dds/ad9951.c b/drivers/staging/iio/dds/ad9951.c
> index 20c1825..d29130e 100644
> --- a/drivers/staging/iio/dds/ad9951.c
> +++ b/drivers/staging/iio/dds/ad9951.c
> @@ -224,18 +224,7 @@ static struct spi_driver ad9951_driver = {
>  	.probe = ad9951_probe,
>  	.remove = __devexit_p(ad9951_remove),
>  };
> -
> -static __init int ad9951_spi_init(void)
> -{
> -	return spi_register_driver(&ad9951_driver);
> -}
> -module_init(ad9951_spi_init);
> -
> -static __exit void ad9951_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad9951_driver);
> -}
> -module_exit(ad9951_spi_exit);
> +module_spi_driver(ad9951_driver);
>  
>  MODULE_AUTHOR("Cliff Cai");
>  MODULE_DESCRIPTION("Analog Devices ad9951 driver");
> diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/iio/gyro/adis16080_core.c
> index 5d7a906..9405f2d 100644
> --- a/drivers/staging/iio/gyro/adis16080_core.c
> +++ b/drivers/staging/iio/gyro/adis16080_core.c
> @@ -189,18 +189,7 @@ static struct spi_driver adis16080_driver = {
>  	.probe = adis16080_probe,
>  	.remove = __devexit_p(adis16080_remove),
>  };
> -
> -static __init int adis16080_init(void)
> -{
> -	return spi_register_driver(&adis16080_driver);
> -}
> -module_init(adis16080_init);
> -
> -static __exit void adis16080_exit(void)
> -{
> -	spi_unregister_driver(&adis16080_driver);
> -}
> -module_exit(adis16080_exit);
> +module_spi_driver(adis16080_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16080/100 Yaw Rate Gyroscope Driver");
> diff --git a/drivers/staging/iio/gyro/adis16130_core.c b/drivers/staging/iio/gyro/adis16130_core.c
> index 749240d..c9aaca9 100644
> --- a/drivers/staging/iio/gyro/adis16130_core.c
> +++ b/drivers/staging/iio/gyro/adis16130_core.c
> @@ -168,18 +168,7 @@ static struct spi_driver adis16130_driver = {
>  	.probe = adis16130_probe,
>  	.remove = __devexit_p(adis16130_remove),
>  };
> -
> -static __init int adis16130_init(void)
> -{
> -	return spi_register_driver(&adis16130_driver);
> -}
> -module_init(adis16130_init);
> -
> -static __exit void adis16130_exit(void)
> -{
> -	spi_unregister_driver(&adis16130_driver);
> -}
> -module_exit(adis16130_exit);
> +module_spi_driver(adis16130_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16130 High Precision Angular Rate");
> diff --git a/drivers/staging/iio/gyro/adis16260_core.c b/drivers/staging/iio/gyro/adis16260_core.c
> index aaa3967..886dddf 100644
> --- a/drivers/staging/iio/gyro/adis16260_core.c
> +++ b/drivers/staging/iio/gyro/adis16260_core.c
> @@ -711,18 +711,7 @@ static struct spi_driver adis16260_driver = {
>  	.remove = __devexit_p(adis16260_remove),
>  	.id_table = adis16260_id,
>  };
> -
> -static __init int adis16260_init(void)
> -{
> -	return spi_register_driver(&adis16260_driver);
> -}
> -module_init(adis16260_init);
> -
> -static __exit void adis16260_exit(void)
> -{
> -	spi_unregister_driver(&adis16260_driver);
> -}
> -module_exit(adis16260_exit);
> +module_spi_driver(adis16260_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16260/5 Digital Gyroscope Sensor");
> diff --git a/drivers/staging/iio/gyro/adxrs450_core.c b/drivers/staging/iio/gyro/adxrs450_core.c
> index 3c3ef79..70fd468 100644
> --- a/drivers/staging/iio/gyro/adxrs450_core.c
> +++ b/drivers/staging/iio/gyro/adxrs450_core.c
> @@ -381,18 +381,7 @@ static struct spi_driver adxrs450_driver = {
>  	.probe = adxrs450_probe,
>  	.remove = __devexit_p(adxrs450_remove),
>  };
> -
> -static __init int adxrs450_init(void)
> -{
> -	return spi_register_driver(&adxrs450_driver);
> -}
> -module_init(adxrs450_init);
> -
> -static __exit void adxrs450_exit(void)
> -{
> -	spi_unregister_driver(&adxrs450_driver);
> -}
> -module_exit(adxrs450_exit);
> +module_spi_driver(adxrs450_driver);
>  
>  MODULE_AUTHOR("Cliff Cai <cliff.cai@xxxxxxxxxx>");
>  MODULE_DESCRIPTION("Analog Devices ADXRS450 Gyroscope SPI driver");
> diff --git a/drivers/staging/iio/imu/adis16400_core.c b/drivers/staging/iio/imu/adis16400_core.c
> index d082a37..efc0f65 100644
> --- a/drivers/staging/iio/imu/adis16400_core.c
> +++ b/drivers/staging/iio/imu/adis16400_core.c
> @@ -1128,18 +1128,7 @@ static struct spi_driver adis16400_driver = {
>  	.probe = adis16400_probe,
>  	.remove = __devexit_p(adis16400_remove),
>  };
> -
> -static __init int adis16400_init(void)
> -{
> -	return spi_register_driver(&adis16400_driver);
> -}
> -module_init(adis16400_init);
> -
> -static __exit void adis16400_exit(void)
> -{
> -	spi_unregister_driver(&adis16400_driver);
> -}
> -module_exit(adis16400_exit);
> +module_spi_driver(adis16400_driver);
>  
>  MODULE_AUTHOR("Manuel Stahl <manuel.stahl@iis.fraunhofer.de>");
>  MODULE_DESCRIPTION("Analog Devices ADIS16400/5 IMU SPI driver");
> diff --git a/drivers/staging/iio/meter/ade7753.c b/drivers/staging/iio/meter/ade7753.c
> index 940fef6..4c7b0cb 100644
> --- a/drivers/staging/iio/meter/ade7753.c
> +++ b/drivers/staging/iio/meter/ade7753.c
> @@ -577,18 +577,7 @@ static struct spi_driver ade7753_driver = {
>  	.probe = ade7753_probe,
>  	.remove = __devexit_p(ade7753_remove),
>  };
> -
> -static __init int ade7753_init(void)
> -{
> -	return spi_register_driver(&ade7753_driver);
> -}
> -module_init(ade7753_init);
> -
> -static __exit void ade7753_exit(void)
> -{
> -	spi_unregister_driver(&ade7753_driver);
> -}
> -module_exit(ade7753_exit);
> +module_spi_driver(ade7753_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADE7753/6 Single-Phase Multifunction Meter");
> diff --git a/drivers/staging/iio/meter/ade7754.c b/drivers/staging/iio/meter/ade7754.c
> index 33f0d32..15c98cd 100644
> --- a/drivers/staging/iio/meter/ade7754.c
> +++ b/drivers/staging/iio/meter/ade7754.c
> @@ -600,18 +600,7 @@ static struct spi_driver ade7754_driver = {
>  	.probe = ade7754_probe,
>  	.remove = __devexit_p(ade7754_remove),
>  };
> -
> -static __init int ade7754_init(void)
> -{
> -	return spi_register_driver(&ade7754_driver);
> -}
> -module_init(ade7754_init);
> -
> -static __exit void ade7754_exit(void)
> -{
> -	spi_unregister_driver(&ade7754_driver);
> -}
> -module_exit(ade7754_exit);
> +module_spi_driver(ade7754_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADE7754 Polyphase Multifunction Energy Metering IC Driver");
> diff --git a/drivers/staging/iio/meter/ade7758_core.c b/drivers/staging/iio/meter/ade7758_core.c
> index c5dafbd..39338bc 100644
> --- a/drivers/staging/iio/meter/ade7758_core.c
> +++ b/drivers/staging/iio/meter/ade7758_core.c
> @@ -853,18 +853,7 @@ static struct spi_driver ade7758_driver = {
>  	.remove = __devexit_p(ade7758_remove),
>  	.id_table = ade7758_id,
>  };
> -
> -static __init int ade7758_init(void)
> -{
> -	return spi_register_driver(&ade7758_driver);
> -}
> -module_init(ade7758_init);
> -
> -static __exit void ade7758_exit(void)
> -{
> -	spi_unregister_driver(&ade7758_driver);
> -}
> -module_exit(ade7758_exit);
> +module_spi_driver(ade7758_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADE7758 Polyphase Multifunction Energy Metering IC Driver");
> diff --git a/drivers/staging/iio/meter/ade7759.c b/drivers/staging/iio/meter/ade7759.c
> index b691f10..cfa2a5e 100644
> --- a/drivers/staging/iio/meter/ade7759.c
> +++ b/drivers/staging/iio/meter/ade7759.c
> @@ -521,18 +521,7 @@ static struct spi_driver ade7759_driver = {
>  	.probe = ade7759_probe,
>  	.remove = __devexit_p(ade7759_remove),
>  };
> -
> -static __init int ade7759_init(void)
> -{
> -	return spi_register_driver(&ade7759_driver);
> -}
> -module_init(ade7759_init);
> -
> -static __exit void ade7759_exit(void)
> -{
> -	spi_unregister_driver(&ade7759_driver);
> -}
> -module_exit(ade7759_exit);
> +module_spi_driver(ade7759_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADE7759 Active Energy Metering IC Driver");
> diff --git a/drivers/staging/iio/meter/ade7854-spi.c b/drivers/staging/iio/meter/ade7854-spi.c
> index cfa23ba..c485a79 100644
> --- a/drivers/staging/iio/meter/ade7854-spi.c
> +++ b/drivers/staging/iio/meter/ade7854-spi.c
> @@ -353,18 +353,7 @@ static struct spi_driver ade7854_driver = {
>  	.remove = __devexit_p(ade7854_spi_remove),
>  	.id_table = ade7854_id,
>  };
> -
> -static __init int ade7854_init(void)
> -{
> -	return spi_register_driver(&ade7854_driver);
> -}
> -module_init(ade7854_init);
> -
> -static __exit void ade7854_exit(void)
> -{
> -	spi_unregister_driver(&ade7854_driver);
> -}
> -module_exit(ade7854_exit);
> +module_spi_driver(ade7854_driver);
>  
>  MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices ADE7854/58/68/78 SPI Driver");
> diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
> index d7ad46a..1c6a02b 100644
> --- a/drivers/staging/iio/resolver/ad2s1200.c
> +++ b/drivers/staging/iio/resolver/ad2s1200.c
> @@ -170,18 +170,7 @@ static struct spi_driver ad2s1200_driver = {
>  	.remove = __devexit_p(ad2s1200_remove),
>  	.id_table = ad2s1200_id,
>  };
> -
> -static __init int ad2s1200_spi_init(void)
> -{
> -	return spi_register_driver(&ad2s1200_driver);
> -}
> -module_init(ad2s1200_spi_init);
> -
> -static __exit void ad2s1200_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad2s1200_driver);
> -}
> -module_exit(ad2s1200_spi_exit);
> +module_spi_driver(ad2s1200_driver);
>  
>  MODULE_AUTHOR("Graff Yang <graff.yang@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices AD2S1200/1205 Resolver to Digital SPI driver");
> diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
> index 6401a62..ff1b331 100644
> --- a/drivers/staging/iio/resolver/ad2s1210.c
> +++ b/drivers/staging/iio/resolver/ad2s1210.c
> @@ -759,18 +759,7 @@ static struct spi_driver ad2s1210_driver = {
>  	.remove = __devexit_p(ad2s1210_remove),
>  	.id_table = ad2s1210_id,
>  };
> -
> -static __init int ad2s1210_spi_init(void)
> -{
> -	return spi_register_driver(&ad2s1210_driver);
> -}
> -module_init(ad2s1210_spi_init);
> -
> -static __exit void ad2s1210_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad2s1210_driver);
> -}
> -module_exit(ad2s1210_spi_exit);
> +module_spi_driver(ad2s1210_driver);
>  
>  MODULE_AUTHOR("Graff Yang <graff.yang@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices AD2S1210 Resolver to Digital SPI driver");
> diff --git a/drivers/staging/iio/resolver/ad2s90.c b/drivers/staging/iio/resolver/ad2s90.c
> index a9200d9..6d07943 100644
> --- a/drivers/staging/iio/resolver/ad2s90.c
> +++ b/drivers/staging/iio/resolver/ad2s90.c
> @@ -119,18 +119,7 @@ static struct spi_driver ad2s90_driver = {
>  	.remove = __devexit_p(ad2s90_remove),
>  	.id_table = ad2s90_id,
>  };
> -
> -static __init int ad2s90_spi_init(void)
> -{
> -	return spi_register_driver(&ad2s90_driver);
> -}
> -module_init(ad2s90_spi_init);
> -
> -static __exit void ad2s90_spi_exit(void)
> -{
> -	spi_unregister_driver(&ad2s90_driver);
> -}
> -module_exit(ad2s90_spi_exit);
> +module_spi_driver(ad2s90_driver);
>  
>  MODULE_AUTHOR("Graff Yang <graff.yang@gmail.com>");
>  MODULE_DESCRIPTION("Analog Devices AD2S90 Resolver to Digital SPI driver");


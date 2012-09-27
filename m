Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2I0MA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:00:56 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:39334 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab2I0MAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:00:54 -0400
Message-ID: <50643FD4.1050508@iki.fi>
Date: Thu, 27 Sep 2012 15:00:20 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: trivial@vger.kernel.org, mchehab@infradead.org, gennarone@gmail.com,
        dan.carpenter@oracle.com, hans.verkuil@cisco.com, thomas@m3y3r.de,
        santoshprasadnayak@gmail.com, abraham.manu@gmail.com,
        stoth@kernellabs.com, dheitmueller@kernellabs.com,
        t.stanislaws@samsung.com, liplianin@netup.ru,
        andriy.shevchenko@linux.intel.com, ptqa@netup.ru, David@Fries.net,
        thunder.mmm@gmail.com, j@jannau.net, s.nawrocki@samsung.com,
        sungchun.kang@samsung.com, khw0178.kim@samsung.com,
        shaik.ameer@samsung.com, hdegoede@redhat.com, tobias.lorenz@gmx.net,
        gregkh@suse.de, paul.gortmaker@windriver.com, m@bues.ch,
        hfvogt@gmx.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] drivers/media: Remove unnecessary semicolon
References: <1348746906-26863-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1348746906-26863-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.186.237
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:55 PM, Peter Senna Tschudin wrote:
> Remove unnecessary semicolon
>
> And:
> drivers/media/dvb-frontends/stv0900_core.c: remove unnecessary whitespace before a
> quoted newline
>
> Found by http://coccinelle.lip6.fr/
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

For my drivers a8293, af9013, af9015, af9035:

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


> ---
>   drivers/media/dvb-core/dvb_frontend.c         |  2 +-
>   drivers/media/dvb-frontends/a8293.c           |  2 +-
>   drivers/media/dvb-frontends/af9013.c          |  6 +++---
>   drivers/media/dvb-frontends/bcm3510.c         |  2 +-
>   drivers/media/dvb-frontends/cx24110.c         |  6 +++---
>   drivers/media/dvb-frontends/drxd_hard.c       |  2 +-
>   drivers/media/dvb-frontends/isl6405.c         |  2 +-
>   drivers/media/dvb-frontends/isl6421.c         |  2 +-
>   drivers/media/dvb-frontends/itd1000.c         |  2 +-
>   drivers/media/dvb-frontends/lnbp21.c          |  4 ++--
>   drivers/media/dvb-frontends/lnbp22.c          |  2 +-
>   drivers/media/dvb-frontends/si21xx.c          |  4 ++--
>   drivers/media/dvb-frontends/sp8870.c          |  6 +++---
>   drivers/media/dvb-frontends/sp887x.c          |  6 +++---
>   drivers/media/dvb-frontends/stv0299.c         |  6 +++---
>   drivers/media/dvb-frontends/stv0900_core.c    |  4 ++--
>   drivers/media/dvb-frontends/tda8083.c         |  4 ++--
>   drivers/media/i2c/cx25840/cx25840-core.c      |  2 +-
>   drivers/media/pci/bt8xx/dst_ca.c              |  2 +-
>   drivers/media/pci/cx23885/altera-ci.c         |  4 ++--
>   drivers/media/pci/cx23885/cimax2.c            |  2 +-
>   drivers/media/pci/cx88/cx88-blackbird.c       |  6 +++---
>   drivers/media/pci/cx88/cx88-dvb.c             |  2 +-
>   drivers/media/pci/cx88/cx88-mpeg.c            |  2 +-
>   drivers/media/pci/cx88/cx88-tvaudio.c         |  4 ++--
>   drivers/media/pci/cx88/cx88-video.c           |  2 +-
>   drivers/media/pci/saa7134/saa7134-video.c     |  2 +-
>   drivers/media/platform/exynos-gsc/gsc-regs.c  |  4 ++--
>   drivers/media/radio/si470x/radio-si470x-i2c.c |  2 +-
>   drivers/media/radio/si470x/radio-si470x-usb.c |  2 +-
>   drivers/media/radio/si4713-i2c.c              | 12 ++++++------
>   drivers/media/usb/dvb-usb-v2/af9015.c         |  4 ++--
>   drivers/media/usb/dvb-usb-v2/af9035.c         |  2 +-
>   33 files changed, 58 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 479a5e5..b5f141a 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2288,7 +2288,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>   		fepriv->tune_mode_flags = (unsigned long) parg;
>   		err = 0;
>   		break;
> -	};
> +	}
>
>   	return err;
>   }
> diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
> index cff44a3..74fbb5d 100644
> --- a/drivers/media/dvb-frontends/a8293.c
> +++ b/drivers/media/dvb-frontends/a8293.c
> @@ -90,7 +90,7 @@ static int a8293_set_voltage(struct dvb_frontend *fe,
>   	default:
>   		ret = -EINVAL;
>   		goto err;
> -	};
> +	}
>
>   	ret = a8293_wr(priv, &priv->reg[0], 1);
>   	if (ret)
> diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
> index e9f04a3..a204f28 100644
> --- a/drivers/media/dvb-frontends/af9013.c
> +++ b/drivers/media/dvb-frontends/af9013.c
> @@ -241,7 +241,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
>   				KBUILD_MODNAME, gpio);
>   		ret = -EINVAL;
>   		goto err;
> -	};
> +	}
>
>   	switch (gpio) {
>   	case 0:
> @@ -253,7 +253,7 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
>   	default:
>   		pos = 4;
>   		break;
> -	};
> +	}
>
>   	ret = af9013_wr_reg_bits(state, addr, pos, 4, gpioval);
>   	if (ret)
> @@ -726,7 +726,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
>   	default:
>   		dev_dbg(&state->i2c->dev, "%s: invalid hierarchy\n", __func__);
>   		auto_mode = 1;
> -	};
> +	}
>
>   	switch (c->modulation) {
>   	case QAM_AUTO:
> diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
> index 033cd7a..1b77909 100644
> --- a/drivers/media/dvb-frontends/bcm3510.c
> +++ b/drivers/media/dvb-frontends/bcm3510.c
> @@ -527,7 +527,7 @@ static int bcm3510_set_frontend(struct dvb_frontend *fe)
>   			cmd.ACQUIRE1.IF_FREQ = 0x0;
>   		default:
>   			return -EINVAL;
> -	};
> +	}
>   	cmd.ACQUIRE0.OFFSET = 0;
>   	cmd.ACQUIRE0.NTSCSWEEP = 1;
>   	cmd.ACQUIRE0.FA = 1;
> diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
> index 3180f5b..0cd6927 100644
> --- a/drivers/media/dvb-frontends/cx24110.c
> +++ b/drivers/media/dvb-frontends/cx24110.c
> @@ -218,7 +218,7 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
>   	   } else
>   		   return -EOPNOTSUPP;
>   /* fixme (low): which is the correct return code? */
> -	};
> +	}
>   	return 0;
>   }
>
> @@ -275,7 +275,7 @@ static int cx24110_set_symbolrate (struct cx24110_state* state, u32 srate)
>   		cx24110_writereg(state,0x07,tmp|0x3);
>   		cx24110_writereg(state,0x06,0x78);
>   		fclk=90999000UL;
> -	};
> +	}
>   	dprintk("cx24110 debug: fclk %d Hz\n",fclk);
>   	/* we need to divide two integers with approx. 27 bits in 32 bit
>   	   arithmetic giving a 25 bit result */
> @@ -362,7 +362,7 @@ static int cx24110_initfe(struct dvb_frontend* fe)
>
>   	for(i = 0; i < ARRAY_SIZE(cx24110_regdata); i++) {
>   		cx24110_writereg(state, cx24110_regdata[i].reg, cx24110_regdata[i].data);
> -	};
> +	}
>
>   	return 0;
>   }
> diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
> index f380eb4..6d98537 100644
> --- a/drivers/media/dvb-frontends/drxd_hard.c
> +++ b/drivers/media/dvb-frontends/drxd_hard.c
> @@ -991,7 +991,7 @@ static int HI_Command(struct drxd_state *state, u16 cmd, u16 * pResult)
>   		if (nrRetries > DRXD_MAX_RETRIES) {
>   			status = -1;
>   			break;
> -		};
> +		}
>   		status = Read16(state, HI_RA_RAM_SRV_CMD__A, &waitCmd, 0);
>   	} while (waitCmd != 0);
>
> diff --git a/drivers/media/dvb-frontends/isl6405.c b/drivers/media/dvb-frontends/isl6405.c
> index 33d33f4..0c642a5 100644
> --- a/drivers/media/dvb-frontends/isl6405.c
> +++ b/drivers/media/dvb-frontends/isl6405.c
> @@ -77,7 +77,7 @@ static int isl6405_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage
>   			break;
>   		default:
>   			return -EINVAL;
> -		};
> +		}
>   	}
>   	isl6405->config |= isl6405->override_or;
>   	isl6405->config &= isl6405->override_and;
> diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
> index 684c8ec..0cb3f0f 100644
> --- a/drivers/media/dvb-frontends/isl6421.c
> +++ b/drivers/media/dvb-frontends/isl6421.c
> @@ -63,7 +63,7 @@ static int isl6421_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	isl6421->config |= isl6421->override_or;
>   	isl6421->config &= isl6421->override_and;
> diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
> index 3164575..c1c3400 100644
> --- a/drivers/media/dvb-frontends/itd1000.c
> +++ b/drivers/media/dvb-frontends/itd1000.c
> @@ -231,7 +231,7 @@ static void itd1000_set_lo(struct itd1000_state *state, u32 freq_khz)
>   	state->frequency = ((plln * 1000) + (pllf * 1000)/1048576) * 2*FREF;
>   	itd_dbg("frequency: %dkHz (wanted) %dkHz (set), PLLF = %d, PLLN = %d\n", freq_khz, state->frequency, pllf, plln);
>
> -	itd1000_write_reg(state, PLLNH, 0x80); /* PLLNH */;
> +	itd1000_write_reg(state, PLLNH, 0x80); /* PLLNH */
>   	itd1000_write_reg(state, PLLNL, plln & 0xff);
>   	itd1000_write_reg(state, PLLFH, (itd1000_read_reg(state, PLLFH) & 0xf0) | ((pllf >> 16) & 0x0f));
>   	itd1000_write_reg(state, PLLFM, (pllf >> 8) & 0xff);
> diff --git a/drivers/media/dvb-frontends/lnbp21.c b/drivers/media/dvb-frontends/lnbp21.c
> index 1343725..f3ba7b5 100644
> --- a/drivers/media/dvb-frontends/lnbp21.c
> +++ b/drivers/media/dvb-frontends/lnbp21.c
> @@ -65,7 +65,7 @@ static int lnbp21_set_voltage(struct dvb_frontend *fe,
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	lnbp21->config |= lnbp21->override_or;
>   	lnbp21->config &= lnbp21->override_and;
> @@ -108,7 +108,7 @@ static int lnbp21_set_tone(struct dvb_frontend *fe,
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	lnbp21->config |= lnbp21->override_or;
>   	lnbp21->config &= lnbp21->override_and;
> diff --git a/drivers/media/dvb-frontends/lnbp22.c b/drivers/media/dvb-frontends/lnbp22.c
> index 84ad039..c463da7 100644
> --- a/drivers/media/dvb-frontends/lnbp22.c
> +++ b/drivers/media/dvb-frontends/lnbp22.c
> @@ -73,7 +73,7 @@ static int lnbp22_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	dprintk(1, "%s: 0x%02x)\n", __func__, lnbp22->config[3]);
>   	return (i2c_transfer(lnbp22->i2c, &msg, 1) == 1) ? 0 : -EIO;
> diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
> index a68a648..73b47cc 100644
> --- a/drivers/media/dvb-frontends/si21xx.c
> +++ b/drivers/media/dvb-frontends/si21xx.c
> @@ -343,7 +343,7 @@ static int si21xx_wait_diseqc_idle(struct si21xx_state *state, int timeout)
>   			return -ETIMEDOUT;
>   		}
>   		msleep(10);
> -	};
> +	}
>
>   	return 0;
>   }
> @@ -472,7 +472,7 @@ static int si21xx_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>   }
>
>   static int si21xx_init(struct dvb_frontend *fe)
> diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
> index e37274c..2aa8ef7 100644
> --- a/drivers/media/dvb-frontends/sp8870.c
> +++ b/drivers/media/dvb-frontends/sp8870.c
> @@ -188,7 +188,7 @@ static int configure_reg0xc05 (struct dtv_frontend_properties *p, u16 *reg0xc05)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	switch (p->hierarchy) {
>   	case HIERARCHY_NONE:
> @@ -207,7 +207,7 @@ static int configure_reg0xc05 (struct dtv_frontend_properties *p, u16 *reg0xc05)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	switch (p->code_rate_HP) {
>   	case FEC_1_2:
> @@ -229,7 +229,7 @@ static int configure_reg0xc05 (struct dtv_frontend_properties *p, u16 *reg0xc05)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	if (known_parameters)
>   		*reg0xc05 |= (2 << 1);	/* use specified parameters */
> diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
> index f4096cc..1bb81b5 100644
> --- a/drivers/media/dvb-frontends/sp887x.c
> +++ b/drivers/media/dvb-frontends/sp887x.c
> @@ -229,7 +229,7 @@ static int configure_reg0xc05(struct dtv_frontend_properties *p, u16 *reg0xc05)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	switch (p->hierarchy) {
>   	case HIERARCHY_NONE:
> @@ -248,7 +248,7 @@ static int configure_reg0xc05(struct dtv_frontend_properties *p, u16 *reg0xc05)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	switch (p->code_rate_HP) {
>   	case FEC_1_2:
> @@ -270,7 +270,7 @@ static int configure_reg0xc05(struct dtv_frontend_properties *p, u16 *reg0xc05)
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	if (known_parameters)
>   		*reg0xc05 |= (2 << 1);	/* use specified parameters */
> diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
> index 057b5f8..92a6075 100644
> --- a/drivers/media/dvb-frontends/stv0299.c
> +++ b/drivers/media/dvb-frontends/stv0299.c
> @@ -199,7 +199,7 @@ static int stv0299_wait_diseqc_fifo (struct stv0299_state* state, int timeout)
>   			return -ETIMEDOUT;
>   		}
>   		msleep(10);
> -	};
> +	}
>
>   	return 0;
>   }
> @@ -216,7 +216,7 @@ static int stv0299_wait_diseqc_idle (struct stv0299_state* state, int timeout)
>   			return -ETIMEDOUT;
>   		}
>   		msleep(10);
> -	};
> +	}
>
>   	return 0;
>   }
> @@ -387,7 +387,7 @@ static int stv0299_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t voltag
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	if (state->config->op0_off)
>   		reg0x0c &= ~0x10;
> diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
> index 7f1bada..262dfa5 100644
> --- a/drivers/media/dvb-frontends/stv0900_core.c
> +++ b/drivers/media/dvb-frontends/stv0900_core.c
> @@ -1552,8 +1552,8 @@ static int stv0900_status(struct stv0900_internal *intp,
>   		bitrate = (stv0900_get_mclk_freq(intp, intp->quartz)/1000000)
>   			* (tsbitrate1_val << 8 | tsbitrate0_val);
>   		bitrate /= 16384;
> -		dprintk("TS bitrate = %d Mbit/sec \n", bitrate);
> -	};
> +		dprintk("TS bitrate = %d Mbit/sec\n", bitrate);
> +	}
>
>   	return locked;
>   }
> diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
> index 15912c9..9d08350 100644
> --- a/drivers/media/dvb-frontends/tda8083.c
> +++ b/drivers/media/dvb-frontends/tda8083.c
> @@ -175,7 +175,7 @@ static void tda8083_wait_diseqc_fifo (struct tda8083_state* state, int timeout)
>   	       !(tda8083_readreg(state, 0x02) & 0x80))
>   	{
>   		msleep(50);
> -	};
> +	}
>   }
>
>   static int tda8083_set_tone (struct tda8083_state* state, fe_sec_tone_mode_t tone)
> @@ -215,7 +215,7 @@ static int tda8083_send_diseqc_burst (struct tda8083_state* state, fe_sec_mini_c
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	tda8083_wait_diseqc_fifo (state, 100);
>
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index d8eac3e..2cee69e 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -599,7 +599,7 @@ static void cx23885_initialize(struct i2c_client *client)
>   		cx25840_write4(client, 0x114, 0x01bf0c9e);
>   		cx25840_write4(client, 0x110, 0x000a030c);
>   		break;
> -	};
> +	}
>
>   	/* ADC2 input select */
>   	cx25840_write(client, 0x102, 0x10);
> diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
> index ee3884f..7d96fab 100644
> --- a/drivers/media/pci/bt8xx/dst_ca.c
> +++ b/drivers/media/pci/bt8xx/dst_ca.c
> @@ -646,7 +646,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
>   		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_PID Success !");
>   	default:
>   		result = -EOPNOTSUPP;
> -	};
> +	}
>    free_mem_and_exit:
>   	kfree (p_ca_message);
>   	kfree (p_ca_slot_info);
> diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
> index aee7f0d..495781e 100644
> --- a/drivers/media/pci/cx23885/altera-ci.c
> +++ b/drivers/media/pci/cx23885/altera-ci.c
> @@ -416,7 +416,7 @@ static void netup_read_ci_status(struct work_struct *work)
>   				DVB_CA_EN50221_POLL_CAM_READY : 0);
>   		ci_dbg_print("%s: setting CI[1] status = 0x%x\n",
>   				__func__, inter->state[1]->status);
> -	};
> +	}
>
>   	if (inter->state[0] != NULL) {
>   		inter->state[0]->status =
> @@ -425,7 +425,7 @@ static void netup_read_ci_status(struct work_struct *work)
>   				DVB_CA_EN50221_POLL_CAM_READY : 0);
>   		ci_dbg_print("%s: setting CI[0] status = 0x%x\n",
>   				__func__, inter->state[0]->status);
> -	};
> +	}
>   }
>
>   /* CI irq handler */
> diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
> index c9f15d6..6617774 100644
> --- a/drivers/media/pci/cx23885/cimax2.c
> +++ b/drivers/media/pci/cx23885/cimax2.c
> @@ -193,7 +193,7 @@ int netup_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot,
>   				0, &store, 1);
>   		if (ret != 0)
>   			return ret;
> -	};
> +	}
>   	state->current_ci_flag = flag;
>
>   	mutex_lock(&dev->gpio_lock);
> diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
> index 843ffd9..3b1aea0 100644
> --- a/drivers/media/pci/cx88/cx88-blackbird.c
> +++ b/drivers/media/pci/cx88/cx88-blackbird.c
> @@ -721,7 +721,7 @@ static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
>
>   	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>   	f->fmt.pix.bytesperline = 0;
> -	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
> +	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
>   	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
>   	f->fmt.pix.width        = dev->width;
>   	f->fmt.pix.height       = dev->height;
> @@ -739,7 +739,7 @@ static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
>
>   	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>   	f->fmt.pix.bytesperline = 0;
> -	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
> +	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
>   	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
>   	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
>   		dev->width, dev->height, fh->mpegq.field );
> @@ -755,7 +755,7 @@ static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
>
>   	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>   	f->fmt.pix.bytesperline = 0;
> -	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
> +	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
>   	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
>   	dev->width              = f->fmt.pix.width;
>   	dev->height             = f->fmt.pix.height;
> diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
> index d803bba..666f83b 100644
> --- a/drivers/media/pci/cx88/cx88-dvb.c
> +++ b/drivers/media/pci/cx88/cx88-dvb.c
> @@ -896,7 +896,7 @@ static int samsung_smt_7020_set_voltage(struct dvb_frontend *fe,
>   		break;
>   	default:
>   		return -EINVAL;
> -	};
> +	}
>
>   	return (i2c_transfer(&dev->core->i2c_adap, &msg, 1) == 1) ? 0 : -EIO;
>   }
> diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
> index c04fb61..d154bc1 100644
> --- a/drivers/media/pci/cx88/cx88-mpeg.c
> +++ b/drivers/media/pci/cx88/cx88-mpeg.c
> @@ -450,7 +450,7 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
>   			cx88_core_irq(core,status);
>   		if (status & PCI_INT_TSINT)
>   			cx8802_mpeg_irq(dev);
> -	};
> +	}
>   	if (MAX_IRQ_LOOP == loop) {
>   		dprintk( 0, "clearing mask\n" );
>   		printk(KERN_WARNING "%s/0: irq loop -- clearing mask\n",
> diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
> index 770ec05..424fd97 100644
> --- a/drivers/media/pci/cx88/cx88-tvaudio.c
> +++ b/drivers/media/pci/cx88/cx88-tvaudio.c
> @@ -373,7 +373,7 @@ static void set_audio_standard_NICAM(struct cx88_core *core, u32 mode)
>   		set_audio_registers(core, nicam_bgdki_common);
>   		set_audio_registers(core, nicam_default);
>   		break;
> -	};
> +	}
>
>   	mode |= EN_DMTRX_LR | EN_DMTRX_BYPASS;
>   	set_audio_finish(core, mode);
> @@ -639,7 +639,7 @@ static void set_audio_standard_A2(struct cx88_core *core, u32 mode)
>   		dprintk("%s Warning: wrong value\n", __func__);
>   		return;
>   		break;
> -	};
> +	}
>
>   	mode |= EN_FMRADIO_EN_RDS | EN_DMTRX_SUMDIFF;
>   	set_audio_finish(core, mode);
> diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
> index f6fcc7e..61f9356 100644
> --- a/drivers/media/pci/cx88/cx88-video.c
> +++ b/drivers/media/pci/cx88/cx88-video.c
> @@ -1535,7 +1535,7 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
>   			cx88_core_irq(core,status);
>   		if (status & PCI_INT_VIDINT)
>   			cx8800_vid_irq(dev);
> -	};
> +	}
>   	if (10 == loop) {
>   		printk(KERN_WARNING "%s/0: irq loop -- clearing mask\n",
>   		       core->name);
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 6de10b1..2cf8ee8 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1204,7 +1204,7 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
>   		break;
>   	default:
>   		/* nothing */;
> -	};
> +	}
>   	switch (c->id) {
>   	case V4L2_CID_BRIGHTNESS:
>   		dev->ctl_bright = c->value;
> diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
> index 0d8625f..0146b35 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-regs.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
> @@ -212,7 +212,7 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
>   		else
>   			cfg |= GSC_IN_YUV422_3P;
>   		break;
> -	};
> +	}
>
>   	writel(cfg, dev->regs + GSC_IN_CON);
>   }
> @@ -332,7 +332,7 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
>   	case 3:
>   		cfg |= GSC_OUT_YUV420_3P;
>   		break;
> -	};
> +	}
>
>   end_set:
>   	writel(cfg, dev->regs + GSC_OUT_CON);
> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
> index f867f04..e449ba7 100644
> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
> @@ -297,7 +297,7 @@ static irqreturn_t si470x_i2c_interrupt(int irq, void *dev_id)
>   					READCHAN_BLERD) >> 10;
>   			rds = radio->registers[RDSD];
>   			break;
> -		};
> +		}
>
>   		/* Fill the V4L2 RDS buffer */
>   		put_unaligned_le16(rds, &tmpbuf);
> diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
> index be076f7..62f3ede 100644
> --- a/drivers/media/radio/si470x/radio-si470x-usb.c
> +++ b/drivers/media/radio/si470x/radio-si470x-usb.c
> @@ -446,7 +446,7 @@ static void si470x_int_in_callback(struct urb *urb)
>   						READCHAN_BLERD) >> 10;
>   				rds = radio->registers[RDSD];
>   				break;
> -			};
> +			}
>
>   			/* Fill the V4L2 RDS buffer */
>   			put_unaligned_le16(rds, &tmpbuf);
> diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
> index b898c89..72f83c4 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -1009,7 +1009,7 @@ static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
>
>   	default:
>   		rval = -EINVAL;
> -	};
> +	}
>
>   	return rval;
>   }
> @@ -1081,7 +1081,7 @@ static int si4713_write_econtrol_string(struct si4713_device *sdev,
>   	default:
>   		rval = -EINVAL;
>   		break;
> -	};
> +	}
>
>   exit:
>   	return rval;
> @@ -1130,7 +1130,7 @@ static int si4713_write_econtrol_tune(struct si4713_device *sdev,
>   	default:
>   		rval = -EINVAL;
>   		goto unlock;
> -	};
> +	}
>
>   	if (sdev->power_state)
>   		rval = si4713_tx_tune_power(sdev, power, antcap);
> @@ -1420,7 +1420,7 @@ static int si4713_read_econtrol_string(struct si4713_device *sdev,
>   	default:
>   		rval = -EINVAL;
>   		break;
> -	};
> +	}
>
>   exit:
>   	return rval;
> @@ -1473,7 +1473,7 @@ static int si4713_read_econtrol_tune(struct si4713_device *sdev,
>   		break;
>   	default:
>   		rval = -EINVAL;
> -	};
> +	}
>
>   unlock:
>   	mutex_unlock(&sdev->mutex);
> @@ -1698,7 +1698,7 @@ static int si4713_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
>   	default:
>   		rval = -EINVAL;
>   		break;
> -	};
> +	}
>
>   	return rval;
>   }
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
> index 824f191..3d7526e 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c
> @@ -500,7 +500,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
>   		case 3:
>   			state->af9013_config[i].clock = 25000000;
>   			break;
> -		};
> +		}
>   		dev_dbg(&d->udev->dev, "%s: [%d] xtal=%d set clock=%d\n",
>   				__func__, i, val,
>   				state->af9013_config[i].clock);
> @@ -568,7 +568,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
>   					"supported, please report!\n",
>   					KBUILD_MODNAME, val);
>   			return -ENODEV;
> -		};
> +		}
>
>   		state->af9013_config[i].tuner = val;
>   		dev_dbg(&d->udev->dev, "%s: [%d] tuner id=%d\n",
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 7d599a9..06a4399 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -519,7 +519,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
>   			dev_warn(&d->udev->dev, "%s: tuner id=%02x not " \
>   					"supported, please report!",
>   					KBUILD_MODNAME, tmp);
> -		};
> +		}
>
>   		/* tuner IF frequency */
>   		ret = af9035_rd_reg(d, EEPROM_1_IFFREQ_L + eeprom_shift, &tmp);
>


-- 
http://palosaari.fi/

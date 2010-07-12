Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0GLXJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:09:23 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45408 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0GLXJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:09:22 -0400
Subject: Re: [PATCH v2] hwmon: Add support for JEDEC JC 42.4 compliant
 temperature sensors
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Goyette <paul@whooppee.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
In-Reply-To: <20100712154949.3230beec.akpm@linux-foundation.org>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
	 <20100712154949.3230beec.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 12 Jul 2010 16:07:41 -0700
Message-ID: <1278976061.11618.147.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 18:49 -0400, Andrew Morton wrote:
> On Sun, 11 Jul 2010 07:53:04 -0700
> Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > +static int jc42_probe(struct i2c_client *new_client,
> > +		      const struct i2c_device_id *id)
> > +{
> > +	struct jc42_data *data;
> > +	int config, cap, err;
> > +
> > +	data = kzalloc(sizeof(struct jc42_data), GFP_KERNEL);
> > +	if (!data) {
> > +		err = -ENOMEM;
> > +		goto exit;
> > +	}
> > +
> > +	i2c_set_clientdata(new_client, data);
> > +	data->valid = false;
> 
> I think it would be acceptable to assume that memset(..., 0, ...) sets
> a bool to `false' ;)
> 
Guess so. Wonder where I got that from. Thanks for noticing...

Guenter



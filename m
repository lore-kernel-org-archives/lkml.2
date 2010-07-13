Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0GMORN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:17:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59783 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751218Ab0GMORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:17:12 -0400
Date: Tue, 13 Jul 2010 15:17:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: lrg@slimlogic.co.uk, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
Message-ID: <20100713141709.GA24260@rakim.wolfsonmicro.main>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
X-Cookie: My EARS are GONE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 07:39:32PM +0530, Sundar Iyer wrote:

> + * @mask: mask to enable/disable regulator
> + * @enable: bits to enable the regulator in normal(high power) mode

Have you addressed my comments here?

> +	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
> +	if (ret < 0) {
> +		dev_dbg(rdev_get_dev(rdev),
> +				"coudlnt get best voltage for regulator\n");

Typo here.  Also, shouldn't your error messages be errors rather than
debug output?

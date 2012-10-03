Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2JCXhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:37:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65222 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab2JCXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:37:18 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Oct 2012 16:37:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org,
        Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Steve Hardy <shardy@redhat.com>
Subject: Re: [PATCH v5 2/2] hwmon: (ads7828) add support for ADS7830
Message-ID: <20121003233758.GC21410@roeck-us.net>
References: <1349297648-19843-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1349297648-19843-2-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297648-19843-2-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:54:08PM -0400, Vivien Didelot wrote:
> From: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> 
> The ADS7830 device is almost the same as the ADS7828,
> except that it does 8-bit sampling, instead of 12-bit.
> This patch extends the ads7828 driver to support this chip.
> 
> Signed-off-by: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied to -next.

Thanks,
Guenter

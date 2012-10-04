Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2JDARO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:17:14 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:34703 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965Ab2JDARN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:17:13 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 20:17:13 EDT
Date: Wed, 3 Oct 2012 20:09:58 -0400 (EDT)
From: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Message-ID: <655051847.640945.1349309398187.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <20121003233758.GC21410@roeck-us.net>
Subject: Re: [PATCH v5 2/2] hwmon: (ads7828) add support for ADS7830
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC21 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Guenter!
Thanks a lot Vivien also for the help.

Guillaume

----- Mail original -----
De: "Guenter Roeck" <linux@roeck-us.net>
À: "Vivien Didelot" <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, "Guillaume Roguez" <guillaume.roguez@savoirfairelinux.com>, "Jean Delvare" <khali@linux-fr.org>, linux-kernel@vger.kernel.org, "Steve Hardy" <shardy@redhat.com>
Envoyé: Mercredi 3 Octobre 2012 19:37:58
Objet: Re: [PATCH v5 2/2] hwmon: (ads7828) add support for ADS7830

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

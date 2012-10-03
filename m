Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab2JCXgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:36:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51527 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab2JCXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:36:50 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Oct 2012 16:37:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>
Subject: Re: [PATCH v5 1/2] hwmon: (ads7828) driver cleanup
Message-ID: <20121003233730.GB21410@roeck-us.net>
References: <1349297648-19843-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297648-19843-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:54:07PM -0400, Vivien Didelot wrote:
> As there is no reliable way to identify the chip, it is preferable to
> remove the detect callback, to avoid misdetection.
> 
> Module parameters are not worth it here, so let's get rid of them and
> add an ads7828_platform_data structure instead.
> 
> Clean the code by removing unused macros, fixing coding style issues,
> avoiding function prototypes and using convenient macros such as
> module_i2c_driver().
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied to -next.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1HOPlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:41:05 -0400
Received: from imr4.ericy.com ([198.24.6.9]:33876 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab1HOPlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:41:03 -0400
Subject: Re: [PATCH v3] hwmon: add caseopen detection to w83627ehf driver
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Ian Dobson <i.dobson@planet-ian.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1313181671-5164-1-git-send-email-mad_soft@inbox.ru>
References: <1313181671-5164-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 15 Aug 2011 08:39:56 -0700
Message-ID: <1313422796.2214.133.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 16:41 -0400, Dmitry Artamonow wrote:
> Export caseopen alarm status into userspace for Winbond W83627*
> and Nuvoton NCT677[56] chips and implement alarm clear knob.
> Second caseopen alarm on NCT6776 is also supported.
> 
> Thanks to Guenter Roeck for information about Nuvoton chips
> and suggestion to use SENSOR_ATTR_2.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Applied to -next.

Thanks,
Guenter



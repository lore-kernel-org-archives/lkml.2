Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab1HPQTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:19:03 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29193 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1HPQTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:19:01 -0400
Date: Tue, 16 Aug 2011 18:18:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, lm-sensors@lm-sensors.org,
        Ian Dobson <i.dobson@planet-ian.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hwmon: add caseopen detection to w83627ehf driver
Message-ID: <20110816181848.2ee10241@endymion.delvare>
In-Reply-To: <1313422796.2214.133.camel@groeck-laptop>
References: <1313181671-5164-1-git-send-email-mad_soft@inbox.ru>
	<1313422796.2214.133.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 08:39:56 -0700, Guenter Roeck wrote:
> On Fri, 2011-08-12 at 16:41 -0400, Dmitry Artamonow wrote:
> > Export caseopen alarm status into userspace for Winbond W83627*
> > and Nuvoton NCT677[56] chips and implement alarm clear knob.
> > Second caseopen alarm on NCT6776 is also supported.
> > 
> > Thanks to Guenter Roeck for information about Nuvoton chips
> > and suggestion to use SENSOR_ATTR_2.
> > 
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> 
> Applied to -next.

Looks very good, thanks to both of you. It's nice to see more drivers
implement this feature after it got standardized.

-- 
Jean Delvare

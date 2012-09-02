Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2IBOvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:51:03 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64479 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2IBOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:51:01 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 2 Sep 2012 07:51:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hwmon: add Maxim MAX197 support
Message-ID: <20120902145101.GA8306@roeck-us.net>
References: <1346377377-24717-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120831160439.GA5756@roeck-us.net>
 <5041D5DF.7060402@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5041D5DF.7060402@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 11:31:11AM +0200, Lars-Peter Clausen wrote:
> On 08/31/2012 06:04 PM, Guenter Roeck wrote:
> > On Thu, Aug 30, 2012 at 09:42:57PM -0400, Vivien Didelot wrote:
> >> The MAX197 is an A/D converter, made by Maxim. This driver currently
> >> supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
> >> 5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.
> >>
> >> The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
> >> 10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
> >>
> >> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > 
> > Applied to -next.
> > 
> 
> Hm, now it's probably to late, but for this kind of general purpose ADC the IIO
> framework is in my opinion the better place to add support for it.
> 
Possibly. If someone writes an iio driver for it, and everyone agrees,
we can drop it from hwmon at that time.

Guenter

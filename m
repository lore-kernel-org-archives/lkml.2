Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2IDPCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:02:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55141 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab2IDPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:02:39 -0400
Subject: Re: [PATCH v3] hwmon: add Maxim MAX197 support
From: anish kumar <anish198519851985@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120902145101.GA8306@roeck-us.net>
References: <1346377377-24717-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <20120831160439.GA5756@roeck-us.net> <5041D5DF.7060402@metafoo.de>
	 <20120902145101.GA8306@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Sep 2012 20:32:28 +0530
Message-ID: <1346770948.6243.3.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-02 at 07:51 -0700, Guenter Roeck wrote:
> On Sat, Sep 01, 2012 at 11:31:11AM +0200, Lars-Peter Clausen wrote:
> > On 08/31/2012 06:04 PM, Guenter Roeck wrote:
> > > On Thu, Aug 30, 2012 at 09:42:57PM -0400, Vivien Didelot wrote:
> > >> The MAX197 is an A/D converter, made by Maxim. This driver currently
> > >> supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
> > >> 5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.
> > >>
> > >> The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
> > >> 10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
> > >>
> > >> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > 
> > > Applied to -next.
> > > 
> > 
> > Hm, now it's probably to late, but for this kind of general purpose ADC the IIO
> > framework is in my opinion the better place to add support for it.
> > 
> Possibly. If someone writes an iio driver for it, and everyone agrees,
> we can drop it from hwmon at that time.
I can write one but unfortunately need some testing as I don't have this
hardware.
> 
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



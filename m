Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0H0DpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 23:45:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48125 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab0H0DpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 23:45:20 -0400
X-Sasl-enc: VKI3kI3lWIE9R9S3hd5xtnMJB8TSfz7pM68XhmY6cUVj 1282880719
Date: Fri, 27 Aug 2010 00:45:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add tempX_emergency to sysfs ABI
Message-ID: <20100827034516.GA29304@khazad-dum.debian.net>
References: <1282838085-7210-1-git-send-email-guenter.roeck@ericsson.com>
 <20100826161022.GA1383@khazad-dum.debian.net>
 <20100826175141.GA19646@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826175141.GA19646@ericsson.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Guenter Roeck wrote:
> > > +temp[1-*]_emergency
> > > +		Temperature emergency value, typically greater than
> > > +		corresponding temp_crit values.
> > > +		Unit: millidegree Celsius
> > > +		RW
> > > +
> > 
> > If we have two-level alarms: critical, then emergency, it is best to have
> > that written down than to imply it by "typically greater than corresponding
> > temp_crit"...
> > 
> How about:
>         Temperature emergency max value, for chips supporting more than
>         two upper temperature limits. Must be equal or greater than
>         corresponding temp_crit values.
>         Unit: millidegree Celsius
>         RW

Much better, thank you.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

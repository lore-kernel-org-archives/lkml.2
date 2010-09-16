Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0IPVkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:40:03 -0400
Received: from imr4.ericy.com ([198.24.6.8]:54871 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0IPVkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:40:02 -0400
Subject: Re: [PATCH 1/2] hwmon: (adm1031) Replace update_rate sysfs
 attribute with update_interval
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100916230234.34f16725@hyperion.delvare>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	 <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
	 <20100916171443.0322bdb6@hyperion.delvare>
	 <20100916153715.GE14165@ericsson.com>
	 <20100916184237.3be9250d@hyperion.delvare>
	 <1284666195.15696.35.camel@groeck-laptop>
	 <20100916230234.34f16725@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 16 Sep 2010 14:39:15 -0700
Message-ID: <1284673155.15696.66.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 17:02 -0400, Jean Delvare wrote:
> On Thu, 16 Sep 2010 12:43:15 -0700, Guenter Roeck wrote:
> > On Thu, 2010-09-16 at 12:42 -0400, Jean Delvare wrote:
> > > I'd rather change all these to "millisecond", so that the document
> > > consistently uses singular for all units.
> > > 
> > > I also see that the indentation isn't consistent, with power and energy
> > > having 4 tabs where the rest has only 2. Bah.
> > > 
> > To get beyond this ... how about you apply my rev2, and I make the other
> > changes (formatting and milliseconds --> millisecond) in a subsequent
> > patch ?
> 
> I'll do the milliseconds --> millisecond myself, no need to resend.
> Further changes would indeed belong to one or two separate patches, if
> you have time for that. This is definitely low priority though.
> 
Ok, thanks

Guenter



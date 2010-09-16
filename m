Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0IPVCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:02:47 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22287 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab0IPVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:02:45 -0400
Date: Thu, 16 Sep 2010 23:02:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: (adm1031) Replace update_rate sysfs 
 attribute with update_interval
Message-ID: <20100916230234.34f16725@hyperion.delvare>
In-Reply-To: <1284666195.15696.35.camel@groeck-laptop>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	<1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
	<20100916171443.0322bdb6@hyperion.delvare>
	<20100916153715.GE14165@ericsson.com>
	<20100916184237.3be9250d@hyperion.delvare>
	<1284666195.15696.35.camel@groeck-laptop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 12:43:15 -0700, Guenter Roeck wrote:
> On Thu, 2010-09-16 at 12:42 -0400, Jean Delvare wrote:
> > I'd rather change all these to "millisecond", so that the document
> > consistently uses singular for all units.
> > 
> > I also see that the indentation isn't consistent, with power and energy
> > having 4 tabs where the rest has only 2. Bah.
> > 
> To get beyond this ... how about you apply my rev2, and I make the other
> changes (formatting and milliseconds --> millisecond) in a subsequent
> patch ?

I'll do the milliseconds --> millisecond myself, no need to resend.
Further changes would indeed belong to one or two separate patches, if
you have time for that. This is definitely low priority though.

-- 
Jean Delvare

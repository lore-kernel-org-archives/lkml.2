Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1FWIpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:45:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29032 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab1FWIpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:45:34 -0400
Date: Thu, 23 Jun 2011 10:45:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ankur Patel <bkankur@gmail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HWMON: TMP102 - Added support for 12 bit data
Message-ID: <20110623104525.30718cd7@endymion.delvare>
In-Reply-To: <BANLkTikLSmXKG67NroavRb+FjzVE5ie21Q@mail.gmail.com>
References: <1308709299-24539-1-git-send-email-bkankur@gmail.com>
	<20110623100616.4573741f@endymion.delvare>
	<BANLkTikLSmXKG67NroavRb+FjzVE5ie21Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 13:56:53 +0530, Ankur Patel wrote:
> On Thu, Jun 23, 2011 at 1:36 PM, Jean Delvare <khali@linux-fr.org> wrote:
> 
> > On Wed, 22 Jun 2011 07:51:39 +0530, Ankur Patel wrote:
> > > From: Ankur Patel <ankur.patel@quipment.in>
> > >
> > > In the tmp102.ko driver support for 12 bit data is added. Also, the
> > > sysfs names are replaced with the actual chip supported fuctionality
> > > names.
> >
> > Nack. These attribute names are standard, see
> > Documentation/hwmon/sysfs-interface. You don't get to change them.
> >
> >
> > What problem were you trying to solve? libsensors expects the attribute
> > names which are in use today.
> >
> > Agree, But using temp1_max_hyst as an attribute for presenting low level
> threshold, will it not more feasible to use temp1_low instead?.

No. This isn't a min temperature limit. Please read the TMP102
datasheet and in particular Figure 10 "Output Transfer Function
Diagrams" and the description of the AL configuration bit.

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab2HGEn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 00:43:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57166 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2HGEn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 00:43:56 -0400
Date: Mon, 6 Aug 2012 21:41:43 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] power_supply: Added support for power supply
 attribute sources
Message-ID: <20120807044143.GA20339@lizard>
References: <1343315844-18824-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120726170411.GA19112@lizard>
 <D854C92F57B1B347B57E531E78D05EAD1C31C9@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD1C31C9@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 06:28:31PM +0000, Pallala, Ramakrishna wrote:
[...]
> > > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > > ---
> > [...]
> > > +extern int power_supply_attributes_register(struct device *parent,
> > > +				struct power_supply_attr_source *psy_attr);
> > 
> > Can you please show some user of the new calls? If I understand correctly,
> > you're going to call these from sensing (ADC, or some
> > other) drivers, which would be very very wrong thing to do.
> 
> I have submitted two patches, one on smb347_charger driver and one on max17042_battery driver
> to demonstrate the use of these API's.
> 
> [PATCH] smb347_charger: Add support for battery power supply attributes registration
> [PATCH] max17042_battery: add support for battery STATUS and CHARGE_TYPE

Yeah, I noticed them, I'll review the whole approach tomorrow.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

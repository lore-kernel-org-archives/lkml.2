Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0HZPlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:41:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1358 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab0HZPlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:41:16 -0400
Subject: Re: [PATCH] Drivers: firewire: Fixed coding style for all the
 files in the directory
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Rotari Razvan-Gabriel <razvanrotari@gmail.com>, clemens@ladisch.de,
        gregkh@suse.de, tj@kernel.org, dbrownell@users.sourceforge.net,
        andre.goddard@gmail.com, jkosina@suse.cz, davem@davemloft.net,
        shemminger@vyatta.com, eric.dumazet@gmail.com,
        martin.petersen@oracle.com, jens.axboe@oracle.com,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C758A00.5070203@s5r6.in-berlin.de>
References: <1282769940-18492-1-git-send-email-razvanrotari@gmail.com>
	 <4C758A00.5070203@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 08:41:11 -0700
Message-ID: <1282837273.1875.60.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 23:24 +0200, Stefan Richter wrote:
> Rotari Razvan-Gabriel wrote:
[]
> > +++ b/drivers/firewire/core-card.c
> > @@ -107,7 +107,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
> >  	j = 7 + descriptor_count;
> > 
> >  	/* Generate root directory entries for descriptors. */
> > -	list_for_each_entry (desc, &descriptor_list, link) {
> > +	list_for_each_entry(desc, &descriptor_list, link) {
> >  		if (desc->immediate > 0)
> >  			config_rom[i++] = cpu_to_be32(desc->immediate);
> >  		config_rom[i] = cpu_to_be32(desc->key | (j - i));
> 
> Not a fix.

Perhaps you could consider it a consistency change for easier grepping

$ grep -rPoh --include=*.[ch] "\blist_for\w+\s*\(" drivers/firewire | sort | uniq -c
      3 list_for_each_entry (
     21 list_for_each_entry(
     10 list_for_each_entry_safe(




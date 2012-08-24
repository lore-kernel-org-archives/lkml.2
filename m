Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2HXEaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:30:00 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41856 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2HXE35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:29:57 -0400
Date: Thu, 23 Aug 2012 21:27:22 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Message-ID: <20120824042722.GA12291@lizard>
References: <1345686558-16512-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120823063005.GL15548@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD23EFED@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD23EFED@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 04:25:15AM +0000, Pallala, Ramakrishna wrote:
> > On Thu, Aug 23, 2012 at 07:19:18AM +0530, Ramakrishna Pallala wrote:
> > > This patch checks for charger status register for determining the
> > > battery charging status and reports Discharing/Charging/Not
> > > Charging/Full accordingly.
> > >
> > > This patch also adds the interrupt support for Safety Timer Expiration.
> > > This interrupt is helpful in debugging the cause for charger fault.
> > >
> > > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > 
> > Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> I got the Ack from Mika can you look into this patch.
> 
> Also I have submitted another patch which needs your attention.
> [PATCH v2] power_supply: Added helper function to get the ps object from supplied_to list

Can you please submit some user of this function?

Thanks!

Anton.

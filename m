Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2CHL4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:56:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:9094 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab2CHL43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:56:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="119012068"
Message-ID: <1331207881.7257.37.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Date: Thu, 08 Mar 2012 13:58:01 +0200
In-Reply-To: <4F587A28.6080205@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1331138007.3463.16.camel@sauron.fi.intel.com>
	 <4F57D0C4.1050605@linutronix.de>
	 <20120308090835.032fe13a@pixies.home.jungo.com>
	 <4F587A28.6080205@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 10:21 +0100, Richard Weinberger wrote:
> On 08.03.2012 08:08, Shmulik Ladkani wrote:
> > But doesn't the CP data (sorry, UBIUBI data :) need to have one
> > 'struct ubi_cp_ec' descriptor for each used/free PEB, and as such the
> > maximum number of 'ubi_cp_ec' descriptors is total device PEBs, meaning
> > CP data is still linearly scaled to device size (with a very small
> > multiplier)?
> >
> 
> It's UBIVIS data. :D

I have a suggestion for the property of the new term. Because your old
one can be both a noun and a verb (write a checkpoint, to checkpoint),
the new term should probably have the same property.

To write the ubibis and to ubibis? Hmm... not sure.

To write the fastmap and to fastmap or decide to not fastmap because all
PEBs within the first 64 have too high erasecounter? Sounds better IMO.

> The size of the checkpoint depends on the number of free/used PEBs.
> But in most cases the checkpoints fits into one or two PEBs.
> Because larger devices have larger erase blocks...

They do, but the eraseblock size grows much slower AFAICS.

-- 
Best Regards,
Artem Bityutskiy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1GNNtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:49:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1GNNtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:49:50 -0400
Date: Thu, 14 Jul 2011 09:49:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pstore dump inside an nmi handler
Message-ID: <20110714134949.GS3765@redhat.com>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
 <20110708214941.GA20511@srcf.ucam.org>
 <20110711153931.GA10083@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E9C9F4A8@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E9C9F4A8@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 11:15:24AM -0700, Luck, Tony wrote:
> > But perhaps, if we detect a spinlock is in use, we can bust it and reset
> > the state machine to solve that problem?
> 
> The ERST table specifies a series of actions to perform to make
> the records get saved to (or read from) the platform persistent
> store. These actions will be dependent on the h/w, and also on
> the creativity of the BIOS writer who composed the ERST action
> table.
> 
> Resetting the state machine looks like it might be tricky from
> any arbitrary point in the sequence.

I agree and I think Matthew told me privately, it would probably be an
untested path, which would make things more problematic.  It would be nice
to have an NVRAM implementation.  That looks simpler and more robust in a
panic path.  But that is up to the vendor's BIOS. :-(

Cheers,
Don

> 
> -Tony

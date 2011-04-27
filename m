Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1D0Gb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1D0Gb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:31:58 -0400
Date: Wed, 27 Apr 2011 12:01:47 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>, Milton Miller <miltonm@bga.com>,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        linuxppc-dev@ozlabs.org
Subject: Re: hvc_console: Don't access hvc_task if not initialised
Message-ID: <20110427063147.GA28328@amit-x200.redhat.com>
References: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com>
 <hvc-kick-notask@mdm.bga.com>
 <20110325084714.GA28356@amit-x200.redhat.com>
 <hvc-kick-notask-2@mdm.bga.com>
 <20110420123330.GB3519@amit-x200.redhat.com>
 <20110420143435.GB22436@kroah.com>
 <20110420170610.GA6013@amit-x200.redhat.com>
 <87oc3sl23a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oc3sl23a.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 27 Apr 2011 [14:31:29], Rusty Russell wrote:
> On Wed, 20 Apr 2011 22:36:10 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> > On (Wed) 20 Apr 2011 [07:34:35], Greg KH wrote:
> > > Care to either create this patch, or resend your original one, if you
> > > want it applied?
> > 
> > Rusty has the other one queued.  I pinged him about status.
> 
> It's merged, but I don't think it had the requisite cc:stable, did it?

No, because at the point of submitting I didn't know it would solve
this bug as well.  Greg, can you pick
afa2689e19073cd2e762d0f2c1358fab1ab9f18c for stable?

Thanks,

		Amit

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1D0GHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:07:18 -0400
Received: from ozlabs.org ([203.10.76.45]:54180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab1D0GHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:07:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>, Greg KH <greg@kroah.com>
Cc: Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, linuxppc-dev@ozlabs.org
Subject: Re: hvc_console: Don't access hvc_task if not initialised
In-Reply-To: <20110420170610.GA6013@amit-x200.redhat.com>
References: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com> <hvc-kick-notask@mdm.bga.com> <20110325084714.GA28356@amit-x200.redhat.com> <hvc-kick-notask-2@mdm.bga.com> <20110420123330.GB3519@amit-x200.redhat.com> <20110420143435.GB22436@kroah.com> <20110420170610.GA6013@amit-x200.redhat.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 27 Apr 2011 14:31:29 +0930
Message-ID: <87oc3sl23a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 22:36:10 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> On (Wed) 20 Apr 2011 [07:34:35], Greg KH wrote:
> > Care to either create this patch, or resend your original one, if you
> > want it applied?
> 
> Rusty has the other one queued.  I pinged him about status.

It's merged, but I don't think it had the requisite cc:stable, did it?

Thanks,
Rusty.

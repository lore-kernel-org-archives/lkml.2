Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab1BPCK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:10:27 -0500
Received: from kroah.org ([198.145.64.141]:48484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab1BPCKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:10:19 -0500
Date: Tue, 15 Feb 2011 17:40:36 -0800
From: Greg KH <greg@kroah.com>
To: "Benenati, Chris J" <chris.j.benenati@intel.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: uio: power management of user-space drivers
Message-ID: <20110216014036.GA29534@kroah.com>
References: <0635488208022A4F82521A04A4772E15C555EC7E@orsmsx503.amr.corp.intel.com>
 <20110215231236.GE2785@local>
 <0635488208022A4F82521A04A4772E15C555EE4E@orsmsx503.amr.corp.intel.com>
 <20110216001847.GF2785@local>
 <0635488208022A4F82521A04A4772E15C555EF7B@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0635488208022A4F82521A04A4772E15C555EF7B@orsmsx503.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, Feb 15, 2011 at 04:35:16PM -0800, Benenati, Chris J wrote:
> Well, for example, a device may have complex application-driven hardware state,
> which in turn in turn can be driven by user inputs. That state will be lost when
> the system powers down.  It might be necessary to invoke the driver suspend()
> function before power is dropped, to read registers and preserve that state.
> It is definitely necessary to call the resume function to reprogram the registers
> when the power is restored.

Then write a real driver for your device if this type of "complex"
hardware state must be controlled.  Don't use UIO for things it was not
ment to be used for.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1EKPsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:48:52 -0400
Received: from imr4.ericy.com ([198.24.6.8]:60486 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1EKPsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:51 -0400
Date: Wed, 11 May 2011 06:52:07 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Nat Gurumoorthy <natg@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Subject: Re: [PATCH v10 2/2] Use "request_muxed_region" in it87 hwmon
 drivers
Message-ID: <20110511135207.GA5928@ericsson.com>
References: <1304966644-19798-1-git-send-email-natg@google.com>
 <1304966731-19896-1-git-send-email-natg@google.com>
 <20110511025338.GB4051@ericsson.com>
 <20110511090044.0b723654@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110511090044.0b723654@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:00:44AM -0400, Jean Delvare wrote:
> On Tue, 10 May 2011 19:53:38 -0700, Guenter Roeck wrote:
> > On Mon, May 09, 2011 at 02:45:31PM -0400, Nat Gurumoorthy wrote:
> > > 02 - Chages to hwmon it87 driver to use "request_muxed_region"
> > > Serialize access to the hardware by using "request_muxed_region" macro defined
> > > by Alan Cox. Call to this macro will hold off the requestor if the resource is
> > > currently busy. "superio_enter" will return an error if call to 
> > > "request_muxed_region" fails. Rest of the code change is to ripple an error
> > > return from superio_enter to the top level.
> > > 
> > > Signed-off-by: Nat Gurumoorthy <natg@google.com>
> > 
> > Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> What's the merge plan for this patch set? I am under the impression
> that, given the current implementation, both patches can be committed
> separately, so each would go upstream through its own tree?
> 
> If this is the case, then I guess Guenter expects me to pick the it87
> part in my hwmon tree? If you prefer to take it in yours, I don't mind,
> I don't have any pending change to the it87 driver.
> 
Frankly, I have not thought about it. But you are right, we can pick it up
separately from the other patch. No preference either way, so please go ahead
and pick it up.

Thanks,
Guenter

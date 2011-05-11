Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1EKSeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:34:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12410 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1EKSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:34:30 -0400
Date: Wed, 11 May 2011 09:00:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Nat Gurumoorthy <natg@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Subject: Re: [PATCH v10 2/2] Use "request_muxed_region" in it87 hwmon 
 drivers
Message-ID: <20110511090044.0b723654@endymion.delvare>
In-Reply-To: <20110511025338.GB4051@ericsson.com>
References: <1304966644-19798-1-git-send-email-natg@google.com>
	<1304966731-19896-1-git-send-email-natg@google.com>
	<20110511025338.GB4051@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011 19:53:38 -0700, Guenter Roeck wrote:
> On Mon, May 09, 2011 at 02:45:31PM -0400, Nat Gurumoorthy wrote:
> > 02 - Chages to hwmon it87 driver to use "request_muxed_region"
> > Serialize access to the hardware by using "request_muxed_region" macro defined
> > by Alan Cox. Call to this macro will hold off the requestor if the resource is
> > currently busy. "superio_enter" will return an error if call to 
> > "request_muxed_region" fails. Rest of the code change is to ripple an error
> > return from superio_enter to the top level.
> > 
> > Signed-off-by: Nat Gurumoorthy <natg@google.com>
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

What's the merge plan for this patch set? I am under the impression
that, given the current implementation, both patches can be committed
separately, so each would go upstream through its own tree?

If this is the case, then I guess Guenter expects me to pick the it87
part in my hwmon tree? If you prefer to take it in yours, I don't mind,
I don't have any pending change to the it87 driver.

-- 
Jean Delvare

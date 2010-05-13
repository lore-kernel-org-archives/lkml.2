Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0EMWgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:36:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54731 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab0EMWgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:36:38 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Greg KH <gregkh@suse.de>, Daniel Walker <dwalker@fifo99.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
       Brian Swetland <swetland@google.com>, Paul Walmsley <paul@pwsan.com>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       "Cousson, Benoit" <b-cousson@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Date: Thu, 13 May 2010 17:33:58 -0500
Subject: RE: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Thread-Topic: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Thread-Index: Acry5gsIxKBzUEByT5+iuZ9DEs1RowABctng
Message-ID: <13B9B4C6EF24D648824FF11BE896716203BB0EEAE9@dlee02.ent.ti.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <201005132311.26293.rjw@sisk.pl>
 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
 <201005132327.16163.rjw@sisk.pl>
 <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
 <20100513214653.GA21120@suse.de>
In-Reply-To: <20100513214653.GA21120@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Thursday, May 13, 2010 4:47 PM

> Also note that such a driver, without wakelocks, would never get tested,
> and so, things start quickly diverging.

Do wakelock enabled drivers require a wakelock aware user space to function properly?  If the driver is added you want to make sure the benefit is there and testable for all userspaces.

Early Android service managers did take/release userspace locks to ensure the handoff worked.

Getting all these drivers is positive.  Getting to some constraint mechanism is positive.  It does need to exist end to end to make a difference at the battery.

Regards,
Richard W.



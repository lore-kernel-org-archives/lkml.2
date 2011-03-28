Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1C1JqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:46:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58052 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751111Ab1C1JqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:46:11 -0400
Date: Mon, 28 Mar 2011 10:46:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>, Feng Tang <feng.tang@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Kp, Jeeja" <jeeja.kp@intel.com>,
        "Fu, Michael" <michael.fu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "meego-kernel@lists.meego.com" <meego-kernel@lists.meego.com>
Subject: Re: [Meego-kernel] [PATCH v9 1/2] mrst: export get_gpio_by_name()
 function
Message-ID: <20110328104615.52c6c03c@lxorguk.ukuu.org.uk>
In-Reply-To: <4D8FF9E5.8000502@linux.intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
	<1301279360-9839-2-git-send-email-guanqun.lu@intel.com>
	<4D8FF3AE.5060003@linux.intel.com>
	<20110328104719.78740624@feng-i7>
	<4D8FF6BB.6030005@linux.intel.com>
	<20110328110053.5355badb@feng-i7>
	<4D8FF9E5.8000502@linux.intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Medfield and MRST are targeting phones. MIDs don't exist... not in this 
> decade.

Well you can take that up with everyone else somewhere offlist, but the
standard naming being used for these devices as a group is mid_xxx, and
has been in the kernel several releases.

> if it was renamed to sfi_get_gpio_by_name() it might make SOME sense, 
> but even then it's a
> gratuitous rename for a function that's already in the upstream kernel.

1. It needs a name that won't clash with anything else or confuse people

2. It shouldn't be exported in the first place but appearing in the PCI
data for the device.

If it must be exported then it definitely needs a rename.

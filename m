Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1HCSxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:53:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44932 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754888Ab1HCSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:52:59 -0400
Date: Wed, 3 Aug 2011 19:56:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Cox, Alan" <alan.cox@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [patch] gma500: restore the wb attribute for the scratch page
Message-ID: <20110803195604.26747424@lxorguk.ukuu.org.uk>
In-Reply-To: <1312396946.7884.7.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1312396946.7884.7.camel@sbsiddha-MOBL3.sc.intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: gma500: restore the wb attribute for the scratch page
> 
> psb_driver_load() is changing the scratch_page attribute to uncached.
> Restore the write-back attribute before freeing the page in the unload
> routine.

Thanks will apply.

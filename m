Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab2DRVTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:19:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44210 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2DRVTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:19:06 -0400
Date: Wed, 18 Apr 2012 22:21:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-1?B?SOV2YXIgTvh2aWs=?= <havar.novik@gmail.com>
Cc: Kristoffer Eriksson <kristoffer.ericson@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        alan@linux.intel.com
Subject: Re: Bug reports on the psb-gfx driver
Message-ID: <20120418222137.0303fe47@pyramind.ukuu.org.uk>
In-Reply-To: <CAJqTQGFD=CCRQGFrhiVk5dEp0bCZ7KbSOsd0HSi_jeSQ4yd9bg@mail.gmail.com>
References: <CAJqTQGEe6rGw4_f-7o2DUZs1J9a=pACuX4KYkLfA0_McMC2Ukg@mail.gmail.com>
	<4F8D532E.4000305@gmail.com>
	<CAJqTQGFD=CCRQGFrhiVk5dEp0bCZ7KbSOsd0HSi_jeSQ4yd9bg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That frequency seems about the same as the one I'm experiences. All though
> some times it's more often, but I can't say I've done anything special at
> the same time.
> 
> 3.3.2-1-ARCH
> Intel(R) Atom(TM) CPU Z520 @ 1.33GHz
> 
> Attachment: dmesg ouput
> 

What X display server are you using (fbdev or other ?). Also I see a few
writes to the brightness in the log - did you fiddle with the brightness
by hand at all ?


Either way I suspect the only way to find this is to verify a
configuration it occurs on, go back a kernel, verify it doesn't happen
there and then build a kernel to the point in the git tree before the
gma500 patches were changed (to check its not caused by something else
such as an ACPI change), then try and find which one caused it.

That will be tedious but unfortunately I've got no documentation or other
good ways to chase this down.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1EKUAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:00:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38876 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218Ab1EKUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:00:20 -0400
Date: Wed, 11 May 2011 21:01:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight
Message-ID: <20110511210139.4a7dc6b4@lxorguk.ukuu.org.uk>
In-Reply-To: <20110511195808.GA5691@patrik-macbook>
References: <20110511172053.GA3557@patrik-macbook>
	<20110511185553.5260805f@bob.linux.org.uk>
	<20110511195808.GA5691@patrik-macbook>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Backlight is only disabled in case no LVDS modes can be found. And in that
> case, no LVDS connector gets added. Am I understanding you correctly if
> "in theory" means LVDS can be hotplugged? In that case we have to call
> psb_intel_lvds_init when hotplug occurs so the output gets added. If so, we
> should put psb_backlight_init() there.

I'm not sure anyone would have a reason to so I don't think anything
needs doing but tagging it as a /* FIXME */ to check and sort out
eventually.


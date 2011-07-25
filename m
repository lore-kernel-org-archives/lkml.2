Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1GYNDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:03:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52607 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751139Ab1GYNDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:03:10 -0400
Date: Mon, 25 Jul 2011 14:06:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: debian-arm@lists.debian.org, linux-kernel@vger.kernel.org,
        Wookey <wookey@wookware.org>
Subject: Re: dynamic LCD support for "embedded" systems
Message-ID: <20110725140610.47fdda27@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
References: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
	<20110725131701.112e635e@lxorguk.ukuu.org.uk>
	<CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> DVI monitor), and that EDID data just gets passed-through via the VGA
> IC. so it's all the same stuff... so what's the damn difference
> between a system with a VGA monitor and a system with the exact same
> LCD panel *from* that VGA monitor, ehn? :)  ok, rhetorical question.

I'm not convinced it is the same stuff for various reaosns and bits of
historical bug fixing and observation.

>  devicetree LCD modules.  these could still be dynamically loaded,
> right?  i mean, it's a bit crazy, but you could have associated with a
> particular LCD panel a devicetree-compliant dynamic loaded module
> which had the correct LCD settings (including the required pre-tested
> hsync and vsync data), right?

In theory, or passed to the kernel at boot. The obvious long term path I
would have thought would have been to move to 'device tree if data present
else...' in the various panel drivers. That way there are no sudden bumps
in the road for distributors but a device tree data set from any source
would trump the data extracted by other means.

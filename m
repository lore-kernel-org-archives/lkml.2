Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1GYMPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:15:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58394 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864Ab1GYMPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:15:06 -0400
Date: Mon, 25 Jul 2011 13:17:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: debian-arm@lists.debian.org, linux-kernel@vger.kernel.org,
        Wookey <wookey@wookware.org>
Subject: Re: dynamic LCD support for "embedded" systems
Message-ID: <20110725131701.112e635e@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
References: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  ok, so.  does anyone on LKML happen to know if there exists in the
> linux kernel a method for dynamic detection and booting off of
> absolutely any type of LCD panel?  even if it's a predefined list of
> say 10 quotes supported quotes static LCD panels?

It depends entirely on the platform, the interconnect, the panel and the
controller. You may have a way of probing it, but even on a PC in a lot
of cases the knowledge is actually in the firmware not in the panel
itself. In some cases the relationship is even more incestuous (eg look
at some of the MIPI drivers).

>  p.s. linus - this is another example of where the complete total
> utter lack of hardware standardisation and of the complete
> non-existence of a BIOS in the embedded / ARM world (for very good
> technical reasons) makes life continued and absolute hell.  ref:
> https://lkml.org/lkml/2011/7/1/473

Well really the panel belongs in devicetree. That would I think sort much
of the mess out.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1BWJNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:13:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60745 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932088Ab1BWJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:13:17 -0500
Date: Wed, 23 Feb 2011 09:14:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before
 slave_data
Message-ID: <20110223091437.0fb888a2@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=jp+q9VYNJvko8P4ju_z86Rw5AxWY9O_reFDai@mail.gmail.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<4D514754.30203@ru.mvista.com>
	<AANLkTinE5x=hmQ6Oykw3Tb38HVeL5eHxjdnPOdMt930q@mail.gmail.com>
	<4D62C5E1.9070307@pobox.com>
	<AANLkTi=NQLxRQ+HAsjtWz5HFu7kaJw9sp50kKyK_ZTDv@mail.gmail.com>
	<20110222111400.1114e8c5@lxorguk.ukuu.org.uk>
	<AANLkTi=jp+q9VYNJvko8P4ju_z86Rw5AxWY9O_reFDai@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> on the other side of equation we have 5 drivers less, 1400 LOCs less,
> no risk of losing bugfixes and features (which is true already w/
> pata_rdc lacking locking fixes + Power Management and pata_oldpiix
> lacking parallel scanning feature).

The parallel scanning feature is somewhat irrelevant on an original PIIX,
if the hardware even supports it which is somewhat of an unknown. If you
have a minor boot time performance concern you'd buy a real computer
instead.

And the other stuff you actually create a problem rather than solving one
- the difficulting testing the rare chips makes it harder to fix ata_piix
bugs and do full testing.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1GOOqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:46:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52425 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752557Ab1GOOqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:46:49 -0400
Date: Fri, 15 Jul 2011 15:48:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, 632187@bugs.debian.org,
        operator@ins.uni-bonn.de, Vasily Averin <vvs@sw.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: megaraid vs i2o for PCI device ID 101e:1960
Message-ID: <20110715154832.09647266@lxorguk.ukuu.org.uk>
In-Reply-To: <1310740196.8783.288.camel@localhost>
References: <4E0C5B57.2020104@ins.uni-bonn.de>
	<handler.632187.B.130943320529363.ack@bugs.debian.org>
	<4E0D8BAE.1000004@ins.uni-bonn.de>
	<1310531358.8783.249.camel@localhost>
	<4E1E989A.2090307@ins.uni-bonn.de>
	<4E1EB3E8.1090503@ins.uni-bonn.de>
	<1310740196.8783.288.camel@localhost>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should this device be blacklisted from i2o_core?  Are there likely other
> MegaRAID devices that use the I2O PCI class but don't work with this
> generic driver?

I²O will probe I²O class devices. How well it works depends upon the
firmware version of the specific board.

The fix in this case is either updated firmware, or to go into the
configuration for the board and turn off I2O support in the bios config.

Alan

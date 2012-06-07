Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776Ab2FGRJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:09:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48392 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2FGRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:09:51 -0400
Date: Thu, 7 Jun 2012 18:13:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Garrett <mjg@redhat.com>, Khalid Aziz <khalid.aziz@hp.com>,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
Message-ID: <20120607181305.2c444be6@pyramind.ukuu.org.uk>
In-Reply-To: <m21ulrjbji.fsf@firstfloor.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	<20120606135009.GB1517@srcf.ucam.org>
	<20120606215034.257d7549@pyramind.ukuu.org.uk>
	<m21ulrjbji.fsf@firstfloor.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But it also makes my system do kexec successfully for the first time.
> 
> Maybe can make it an option.

More useful might be to report which devices have the bus master bit left
on at the time you tried the kexec, then we might actually find the bug.

Alan

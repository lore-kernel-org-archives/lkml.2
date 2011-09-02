Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1IBNq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:46:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58016 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160Ab1IBNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:46:58 -0400
Date: Fri, 2 Sep 2011 14:46:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Azat Khuzhin <dohardgopro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IDE driver for HDD WDC WD1600JB-00R 160G
Message-ID: <20110902144600.46117a5c@lxorguk.ukuu.org.uk>
In-Reply-To: <CAAW1UO-9uvc6zUAm0FUB5CE9ptGt9FN=644HbY4qgi9T_tuBhg@mail.gmail.com>
References: <CAAW1UO-9uvc6zUAm0FUB5CE9ptGt9FN=644HbY4qgi9T_tuBhg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dma 131072 in
> [   75.058789]          res 51/84:8f:f1:66:5c/00:00:00:00:00/e4 Emask
> 0x30 (host bus error)
> [   75.058794] ata4.00: status: { DRDY ERR }
> [   75.058797] ata4.00: error: { ICRC ABRT }
> [   75.058815] ata4: soft resetting link

The data transfer between the OS and drive was corrupted. The driver is
erroring the command reporting this.

It usually indicates cabling problems as the checksums for this are
computed and checked by the hardware not Linux.

Alan

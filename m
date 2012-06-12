Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab2FLKJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:09:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53837 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2FLKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:09:16 -0400
Date: Tue, 12 Jun 2012 11:12:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CPU MTRRs and linux kernel
Message-ID: <20120612111259.48862b67@pyramind.ukuu.org.uk>
In-Reply-To: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 02:37:40 -0700 (PDT)
Mahmood Naderan <nt_mahmood@yahoo.com> wrote:

> Hi everybody,
> Abour rhis warnning in boot log:
> 
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952MB of RAM

           ^^^^^ Note what it says here

> Should I upgrade?

Your BIOS perhaps.

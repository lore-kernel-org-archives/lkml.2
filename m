Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1DWJet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 05:34:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36233 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752743Ab1DWJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 05:34:47 -0400
Date: Sat, 23 Apr 2011 10:35:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Samuel <chris@csamuel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
Message-ID: <20110423103536.1c7ff2a8@lxorguk.ukuu.org.uk>
In-Reply-To: <201104231016.23579.chris@csamuel.org>
References: <201104222333.25546.chris@csamuel.org>
	<20110422173422.46134f20@lxorguk.ukuu.org.uk>
	<201104231016.23579.chris@csamuel.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 10:16:18 +1000
Chris Samuel <chris@csamuel.org> wrote:

> Syt mae Alan! ;-)

G'day ;)

> Ahh, that's a new one on me, and it reveals that the kernel
> has gone from 2.6.18 detecting:
> 
> 256MB LOWMEM available.
> 
> to 2.6.39-rc4 detecting:
> 
> 16MB LOWMEM available.
> 
> That would explain an awful lot..

Could be something has disturbed its memory detect or could be a bug in
the PPro memory quirk.

If you boot with mem= and force the memory size what happens ?

> INT 15h = f000:f859 DOS RAM: 638K (0x9f800) INT 12h: 638K (0x9f800)
> INT 15 88: 0x3c00 (15360K) INT 15 E801: 0x0000 (0K) 0x0000 (0K)

Ah.. do you have a BIOS setting called something like OS/2 compatibility ?

> Hope life is still good in Abertawe!

This part of the world has changed rather a lot. Not sure you'd recognize
half of it.

Alan

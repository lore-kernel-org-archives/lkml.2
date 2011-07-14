Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1GNIvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:51:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36409 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753107Ab1GNIvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:51:12 -0400
Date: Thu, 14 Jul 2011 09:53:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Jan H." =?ISO-8859-14?B?U2No9m5oZXJy?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'
Message-ID: <20110714095324.787f3ff1@lxorguk.ukuu.org.uk>
In-Reply-To: <1310590281.2586.34.camel@twins>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	<1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>
	<1310590281.2586.34.camel@twins>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 22:51:21 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2011-07-13 at 20:13 +0200, Jan H. Schönherr wrote:
> > From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
> 
> WTF am I to do with crap like that?! 

Fix your mail client ? It should be recognizing the UTF8 indicators, and
git itself is utf-8 clean.

Alan

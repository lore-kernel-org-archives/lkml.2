Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1ECJmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:42:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50523 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751406Ab1ECJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:42:18 -0400
Date: Tue, 3 May 2011 10:42:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110503104258.5a808b9d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110502192256.GL4556@quack.suse.cz>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
	<20110429162817.2eb26efb.akpm@linux-foundation.org>
	<20110430112937.06024368@lxorguk.ukuu.org.uk>
	<20110430153452.GA21439@suse.de>
	<20110430164141.55d0ef0a@lxorguk.ukuu.org.uk>
	<20110502192256.GL4556@quack.suse.cz>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So if people don't like vmalloc() (which I can understand), then I see no
> other option than dynamically allocating struct raw_device_data.

That gets rather more complicated.

So yes I agree your question is a good one - for smaller sizes I'd rather
see it from the kmalloc/static pool but for small sizes it also doesn't
matter much anyway.

Objection rescinded - I think you've proved convincingly that the only
way to sort it properly is horribly complicated

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0KIKhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:37:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57764 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754105Ab0KIKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:37:12 -0500
Date: Tue, 9 Nov 2010 10:35:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tty: prevent DOS in the flush_to_ldisc
Message-ID: <20101109103539.089fae14@lxorguk.ukuu.org.uk>
In-Reply-To: <20101108180147.GB3275@jolsa.brq.redhat.com>
References: <1288163451-3973-1-git-send-email-jolsa@redhat.com>
	<20101108134840.GA3275@jolsa.brq.redhat.com>
	<20101108140938.06b7ee65@lxorguk.ukuu.org.uk>
	<20101108180147.GB3275@jolsa.brq.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The attached patch (based on -next tree) fixes this by checking on the
> tty buffer tail. Once it's reached, the current work is rescheduled
> and another could run.

Looks nice and tidy

Alan

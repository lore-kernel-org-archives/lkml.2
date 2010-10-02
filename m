Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0JBN5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 09:57:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59537 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755480Ab0JBN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 09:57:48 -0400
Date: Sat, 2 Oct 2010 15:22:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Drake <dsd@laptop.org>
Cc: akpm@linux-foundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial8250: ratelimit "too much work" error
Message-ID: <20101002152229.5f0f957b@lxorguk.ukuu.org.uk>
In-Reply-To: <20101002110438.801F49D401B@zog.reactivated.net>
References: <20101002110438.801F49D401B@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  2 Oct 2010 12:04:38 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Running a serial console, if too many kernel messages are generated within
> a short time causing a lot of serial I/O, the 8250 driver will generate
> another kernel message reporting this, which just adds to the I/O. It has
> a cascading effect and quickly results the system being brought to its knees
> by a flood of "too much work" messages.
> 
> Ratelimit the error message to avoid this.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Alan Cox <alan@linux.intel.com>


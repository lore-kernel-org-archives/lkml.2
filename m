Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0G2PTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:19:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33804 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757701Ab0G2PTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:19:32 -0400
Date: Thu, 29 Jul 2010 16:31:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
        <ludovic.barre@stericsson.com>, <vincent.guittot@stericsson.com>
Subject: Re: [PATCH] U6715 16550A serial driver support
Message-ID: <20100729163148.3b26e379@lxorguk.ukuu.org.uk>
In-Reply-To: <1280416437-25364-1-git-send-email-philippe.langlais@stericsson.com>
References: <1280416437-25364-1-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 17:13:57 +0200
Philippe Langlais <philippe.langlais@stericsson.com> wrote:

> UART Features extract from STEricsson U6715 data-sheet (arm926 SoC for mobile phone):
> * Fully compatible with industry standard 16C550 and 16C450 from various

Acked-by: Alan Cox <alan@linux.intel.com>


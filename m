Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2G2M7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 08:59:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51939 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2G2M7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 08:59:08 -0400
Date: Sun, 29 Jul 2012 14:00:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel..." <kernel-janitors@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: appletalk/cops_probe BUG: soft lockup - CPU#1 stuck for 23s!
Message-ID: <20120729140003.6fa483d2@ultron>
In-Reply-To: <20120729124022.GA16748@localhost>
References: <20120729124022.GA16748@localhost>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2012 20:40:22 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> Hi,
> 
> This is probably a rather old bug, triggered while doing randconfig
> boot tests in kvm:

I'm not sure testing old devices with no safe probe method is useful in
this context ?

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0HJIcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 04:32:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33127 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522Ab0HJIcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 04:32:13 -0400
Date: Tue, 10 Aug 2010 09:45:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andi@firstfloor.org, gregkh@suse.de, tytso@mit.edu,
        iws@ovro.caltech.edu
Subject: Re: [PATCH 1/4] fix kfifo miss use of nozami.c
Message-ID: <20100810094544.3d5e2cec@lxorguk.ukuu.org.uk>
In-Reply-To: <1281422440-23455-2-git-send-email-stefani@seibold.net>
References: <1281422440-23455-1-git-send-email-stefani@seibold.net>
	<1281422440-23455-2-git-send-email-stefani@seibold.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010 08:40:37 +0200
stefani@seibold.net wrote:

> From: Stefani Seibold <stefani@seibold.net>
> 
> User of the kernel fifo should never bypass the API and directly access
> the fifo structure. Otherwise it will be very hard to maintain the API.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Acked-by: Alan Cox <alan@linux.intel.com>

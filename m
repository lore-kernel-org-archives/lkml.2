Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab1D0Uj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:39:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755722Ab1D0Ujy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:39:54 -0400
Date: Wed, 27 Apr 2011 21:40:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <johnlinn@comcast.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <michal.simek@petalogix.com>, <joe@perches.com>,
        <grant.likely@secretlab.ca>, <greg@kroah.com>,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
Message-ID: <20110427214045.6f6d179d@lxorguk.ukuu.org.uk>
In-Reply-To: <beef0ca4-f7d3-4f61-b22a-d9eeeb0618f4@VA3EHSMHS010.ehs.local>
References: <beef0ca4-f7d3-4f61-b22a-d9eeeb0618f4@VA3EHSMHS010.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 12:17:36 -0600
<johnlinn@comcast.net> wrote:

> From: John Linn <john.linn@xilinx.com>
> 
> The Xilinx PS Uart is used on the new ARM based SoC. This
> UART is not compatible with others such that a seperate
> driver is required.
> 
> Signed-off-by: John Linn <john.linn@xilinx.com>

Acked-by: Alan Cox <alan@linux.intel.com>

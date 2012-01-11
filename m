Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2AKM3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:29:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43603 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2AKM3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:29:50 -0500
Date: Wed, 11 Jan 2012 12:30:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rajanikanth H V <rajanikanth.hv@stericsson.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@sude.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tty/serial: Need clarification on Support for 4+M Baudrate
Message-ID: <20120111123025.244a9cf5@pyramind.ukuu.org.uk>
In-Reply-To: <20120111121901.GA4034@bnru05>
References: <20120111121901.GA4034@bnru05>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 17:49:01 +0530
> I have a requirement to interface UART with an external microcontroller 
> using baud rate above 4Mbps, hence following is my approach to apply
> the changes. Can any one review/provide me appropriate approach.

See TCGETS2/TCSETS2 and the BOTHER flag.

The kernel supports aetting arbitary baud rates already.

Alan

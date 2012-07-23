Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2GWJtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 05:49:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44310 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2GWJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 05:49:07 -0400
Date: Mon, 23 Jul 2012 10:52:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Blanchard <anton@samba.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable devtmpfs by default
Message-ID: <20120723105227.28e3d792@pyramind.ukuu.org.uk>
In-Reply-To: <20120723115414.724e0046@kryten>
References: <20120723115414.724e0046@kryten>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012 11:54:14 +1000
Anton Blanchard <anton@samba.org> wrote:

> 
> udev now requires CONFIG_DEVTMPFS so make it default to y.
> 
> I noticed this when booting a ppc64 pseries_defconfig on Fedora 17
> and it paniced because it couldn't mount the root device.

NAK. As Linus keeps saying we shouldn't go randomly turning features on
at people.

See the discussion on having a distro configuration - that will fix this
problem properly and for good.

You need half a dozen other things enabled to make Fedora boot many of
them quite obscure LVM settings.

Alan

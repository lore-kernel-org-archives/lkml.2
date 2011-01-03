Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1ACRPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:15:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53119 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895Ab1ACRPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:15:31 -0500
Date: Mon, 3 Jan 2011 17:14:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char nvtty: Network Virtual Terminal support
Message-ID: <20110103171452.5e258743@lxorguk.ukuu.org.uk>
In-Reply-To: <1294067735-21466-2-git-send-email-giometti@linux.it>
References: <1294067735-21466-1-git-send-email-giometti@linux.it>
	<1294067735-21466-2-git-send-email-giometti@linux.it>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By using these devices and a proper compatible server (not included
> here but you can use sredird) you can get access to a remote tty
> device as the tty device itself was conneted with your local host.
> All data and settings are sent and received through the network.

Interesting but would it not be better to keep all the network stuff in
user space given that most sane environments will have crypto on them ?

It's also a less than ideal protocol in that it can't represent some of
the things termios can, nor can it report arbitary speeds properly.

Is there a reason it couldn't use pty/tty pairs either as is or tweaked
to better report termios changes and allow modem line reporting ?

Alan

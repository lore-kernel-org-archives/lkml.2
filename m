Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1LELhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:37:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46631 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab1LELhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:37:40 -0500
Date: Mon, 5 Dec 2011 11:38:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 2/2] serial: bfin-uart: remove redundant CTS check for
 hardware CTS control.
Message-ID: <20111205113840.02e42ffa@lxorguk.ukuu.org.uk>
In-Reply-To: <1323079991-4855-2-git-send-email-sonic.adi@gmail.com>
References: <1323079991-4855-1-git-send-email-sonic.adi@gmail.com>
	<1323079991-4855-2-git-send-email-sonic.adi@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 18:13:11 +0800
Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Blackfin hardware CTS control generate interrupt for both CTS on and off.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Both

Acked-by: Alan Cox <alan@linux.intel.com>

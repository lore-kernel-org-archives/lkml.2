Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab2IQK4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:56:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab2IQK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:56:07 -0400
Date: Mon, 17 Sep 2012 12:00:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Olof Johansson <olof@lixom.net>, Peter Jones <pjones@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86: Switch to vga console only if framebuffer details
 are missing
Message-ID: <20120917120047.42b520ac@pyramind.ukuu.org.uk>
In-Reply-To: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
References: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 11:29:08 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@intel.com>
> 
> The efi_enabled variable has come to mean "Do we have EFI runtime
> services available?". However, lack of EFI runtime services does not
> mean that we should switch to using the VGA console. Provided that the
> boot loader passed the dimensions of the EFI framebuffer there is no
> reason we can't use efifb.

Speed is the obvious one. vga con is fast, efifb is not

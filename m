Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0HIOxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:53:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54914 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756685Ab0HIOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:53:49 -0400
Date: Mon, 9 Aug 2010 16:08:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] tty: add tty_struct->dev pointer to corresponding
 device instance
Message-ID: <20100809160819.42e8c84e@lxorguk.ukuu.org.uk>
In-Reply-To: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
References: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Aug 2010 18:22:49 +0400
Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> Some device drivers (mostly tty line disciplines) would like to have way
> know a struct device instance corresponding to passed tty_struct. Add
> a struct device pointer to struct tty_struct and populate it during
> initialize_tty_struct().

Acked-by: Alan Cox <alan@linux.intel.com>

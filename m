Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0GNLmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:42:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59246 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753600Ab0GNLmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:42:10 -0400
Date: Wed, 14 Jul 2010 12:50:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/3] usb/gadget: Remove dead CONFIG_USB_LANGWELL_OTG
Message-ID: <20100714125027.20108731@lxorguk.ukuu.org.uk>
In-Reply-To: <4dd884f3ca70240035a8810d430e35ccf7d54ac3.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<4dd884f3ca70240035a8810d430e35ccf7d54ac3.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 13:31:55 +0200
Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de> wrote:

> CONFIG_USB_LANGWELL_OTG doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

NAK

If you followed the USB list you would be aware this was work currently
being moved towards merge.


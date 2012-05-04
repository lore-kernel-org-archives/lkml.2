Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2EDQbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:31:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59163 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2EDQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:31:13 -0400
Date: Fri, 4 May 2012 17:33:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Stein <a.stein@systec-electronic.com>
Cc: Preston Fick <pffick@gmail.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, preston.fick@silabs.com
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120504173356.000fb9da@pyramind.ukuu.org.uk>
In-Reply-To: <1436626.86ImxHLlqB@ws-stein>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
	<1436626.86ImxHLlqB@ws-stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2012 18:26:58 +0200
Alexander Stein <a.stein@systec-electronic.com> wrote:

> Am Montag, 30. April 2012, 15:27:17 schrieb Preston Fick:
> > This fix contains several changes that allow toggling of GPIO on CP210x
> > devices that support it. Changes include:
> > * Added in part number support, necessary to see if the connected device
> > supports the GPIO functionality
> > * Added two IOCTLs and ioctl function to allow GET/SET of GPIO
> > * Added in new #defines for partnum support, new USB requests
> > * Changed "Config request types" section to contain more correct definitions
> > for request recipient
> > 
> > Signed-off-by: Preston Fick <preston.fick@silabs.com>
> 
> Do you actually need to create new ioctls? You also could support gpiolib and 
> create a gpiochip for that.

See my follow up posting, and comment on that proposal.

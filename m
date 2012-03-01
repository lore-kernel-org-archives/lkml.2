Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2CAAJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:09:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53761 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2CAAJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:09:53 -0500
Date: Thu, 1 Mar 2012 00:11:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com
Subject: Re: [PATCH 1/3] drivers/misc: add support for BMP18x pressure
 sensors
Message-ID: <20120301001143.02f6c8c4@pyramind.ukuu.org.uk>
In-Reply-To: <1330545489-31169-2-git-send-email-eric.andersson@unixphere.com>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
	<1330545489-31169-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 20:58:07 +0100
Eric Andersson <eric.andersson@unixphere.com> wrote:

> This driver adds support for Bosch Sensortec's pressure sensors
> BMP085 and BMP18x.
> 
> The driver is based on the bmp085 driver by Christoph Mair
> and uses the same sysfs interface.

This is really extending bmp085 to cover the 18x chips. We don't normally
rename everything for that, and you risk breaking existing setups
assuming the module name is bmp085.

So please just "update" the existing driver - ie the code looks fine but
it should still end up being bmp085.

Alan

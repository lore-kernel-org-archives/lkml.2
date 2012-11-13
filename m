Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2KMWhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:37:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51293 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KMWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:37:39 -0500
Date: Tue, 13 Nov 2012 22:42:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH] i2c: i2c-tiny-usb: Add parameter for optional
 i2c-devices.
Message-ID: <20121113224251.20b52f34@pyramind.ukuu.org.uk>
In-Reply-To: <1352839940-7559-1-git-send-email-holler@ahsoftware.de>
References: <50A2AC28.7050304@ahsoftware.de>
	<1352839940-7559-1-git-send-email-holler@ahsoftware.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 21:52:20 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> Make it possible to define i2c-devices at the kernel command line
> or as a module parameter.
> 
> Format is devname1@addr1,devname2@addr2,...

Why not do this with your initrd, you can deal with your rtc
before mounting the real root fs.

Alan

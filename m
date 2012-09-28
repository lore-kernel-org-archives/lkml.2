Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2I1MtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:49:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47582 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab2I1MtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:49:19 -0400
Date: Fri, 28 Sep 2012 13:54:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver
Message-ID: <20120928135401.6781d134@pyramind.ukuu.org.uk>
In-Reply-To: <1348818032.10877.325.camel@rui.sh.intel.com>
References: <1348818032.10877.325.camel@rui.sh.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012 15:40:32 +0800
Zhang Rui <rui.zhang@intel.com> wrote:

> >From 6077a62f2865201ab6727ca7d628ee5e43aa57e1 Mon Sep 17 00:00:00 2001
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Fri, 24 Aug 2012 15:18:25 +0800
> Subject: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
>  driver
> 
> This driver is able to
> 1) enumerate I2C controller via ACPI namespace
>    and register it as a platform device.
> 2) enumerate I2C slave devices via ACPI namespace.

Will this also trigger and work with the ACPI4 based devices that seem to
have I²C tables that Linux currently doesn't understand (eq some
GMA600/Oaktrail platforms) ?


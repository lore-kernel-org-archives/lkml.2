Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2EZH7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:59:25 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:52816 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2EZH7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:59:24 -0400
Date: Sat, 26 May 2012 09:58:55 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 6/6] serial: add amba-pl011-pci
Message-ID: <20120526075855.GA1702@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <201205260739.31653.arnd@arndb.de>
References: <201205260739.31653.arnd@arndb.de>
  <cover.1337959750.git.rubini@gnudd.com>
 <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aside from the dma mask, this looks almost entirely generic. Would it
> be possible to make this a generic pci-amba driver that lives under
> drivers/amba/ and does not care about the type of device behind it?

Yes, it's possible. Actually, this was my longer-time plan: propose a
factorization when more of those were ready.  So I'll remove the
special name in the device and offer an implementation as generic
as possible.

BTW, are the prerequisite patches of with you?

thanks
/alessandro

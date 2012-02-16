Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2BPSUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:20:51 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64799 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab2BPSUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:20:50 -0500
Date: Thu, 16 Feb 2012 19:20:23 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: sam@ravnborg.org
Cc: arnd@arndb.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH] ARM: amba: don't include <asm/sizes.h>
Message-ID: <20120216182023.GA18485@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120216172551.GA31306@merkur.ravnborg.org>
References: <20120216172551.GA31306@merkur.ravnborg.org>
  <20120216160525.GA30558@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be good to have it included for all architectures.
> It really has nothing arch specific in it so it ought to live in
> include/linux:
> 
>     git mv include/asm-generic include/linux

Ok. I can do this if it has any chance to be accepted.  I find more
and more SZ_4K as I dig into my PCIe-AMBA bridge.

/alessandro

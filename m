Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2E2GiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:38:09 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:48244 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab2E2GiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:38:08 -0400
Date: Tue, 29 May 2012 08:37:38 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
Message-ID: <20120529063738.GA22711@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4FC40C74.8050003@zytor.com>
References: <4FC40C74.8050003@zytor.com>
  <20120527205020.GA3050@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is absolutely NO WAY this kind of ARM-like sh*t is going into the
> x86 kernel.

Ok. Then, how do you suggest to provide platform data to the various
drivers?  It really depends on how the board is wired.

BTW: it's not uncommon for pci cards to differ in the same way, see
drivers/media/video/bt8xx/bttv-cards.c for example.  I can have all
board configurations without config choices or whatever is acceptable.
Just tell me how to proceed.

thanks
/alessandro

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab2AFUTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:19:16 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61564 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759105Ab2AFUTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:19:15 -0500
Date: Fri, 6 Jan 2012 21:18:56 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 1/6] pci_ids: add device ids for STA2X11 device (aka
 ConneXT)
Message-ID: <20120106201856.GA8864@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120106121154.48b570e8@jbarnes-desktop>
References: <20120106121154.48b570e8@jbarnes-desktop>
  <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applied, thanks.  Will the users land this release too?

It's a lot of code, and I'm working on it. I'll have patches for the
individual drivers over the next months.

The main user, the arch/x86/platform/sta2x11 place is almost ready but
I want to test better approaches internally rather then submitting and
fixing soon after.

thanks
/alessandro

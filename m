Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab2FDKSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:18:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:32946 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2FDKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:18:18 -0400
Message-ID: <1338805068.7150.78.camel@pasglop>
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org
Date: Mon, 04 Jun 2012 20:17:48 +1000
In-Reply-To: <20120529070557.GA23373@mail.gnudd.com>
References: <4FC47003.1080906@zytor.com>  <4FC40C74.8050003@zytor.com>
	 <20120527205020.GA3050@mail.gnudd.com>
	 <20120529063738.GA22711@mail.gnudd.com>
	 <20120529070557.GA23373@mail.gnudd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 09:05 +0200, Alessandro Rubini wrote:
> 
> It doesn't. I'm currently developing using an add-on pci card running
> on a more conventional computer (and there you may object it is not
> even x86-specific, actually I'd love to see it sold as a separate card
> for industrial use). 

If it's an add-on card, can't you put a flash on it ? Then you can stick
discovery/configuration information there or even a device-tree blob
accessed via a BAR (or even the ROM BAR).

Cheers,
Ben.



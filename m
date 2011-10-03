Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab1JCS0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:26:35 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:47284 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab1JCS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:26:27 -0400
X-SENDER-IP: [85.230.170.153]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtJfACX+iU5V5qqZPGdsb2JhbABCiSyeVhkBAQEBNzKBUwEBBTocIxAIAw4KLhQlChqIELhKDoYyYQSZE4wN
X-IronPort-AV: E=Sophos;i="4.68,480,1312149600"; 
   d="scan'208";a="124143258"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 3 Oct 2011 20:32:06 +0200
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        MikeWaychiso@bitmath.org
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
Message-ID: <20111003183206.GA2914@polaris.bitmath.org>
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
 <1316607036-9235-1-git-send-email-matt@console-pimps.org>
 <20110929101418.GA2215@polaris.bitmath.org>
 <1317368465.3375.6.camel@mfleming-mobl1.ger.corp.intel.com>
 <20110930111312.GA6567@polaris.bitmath.org>
 <20111003165332.GA22562@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003165332.GA22562@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:53:32PM +0100, Matthew Garrett wrote:
> On Fri, Sep 30, 2011 at 01:13:12PM +0200, Henrik Rydberg wrote:
> 
> > No, sorry, it never worked on this machine when booting from EFI.
> > AFAICT, there is no known way to control backlight either (nvidia
> > 320M). If you have a similar setup, sharing findings would be most
> > interesting (off-line).
> 
> Should work with current nouveau git.

Indeed! Graphics, backlight and resume works. Outstanding, thank you.

Henrik

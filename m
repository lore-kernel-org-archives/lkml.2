Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0K3Ubd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:31:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0K3Ubc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:31:32 -0500
Date: Tue, 30 Nov 2010 12:27:12 -0800
From: Greg KH <gregkh@suse.de>
To: Andreas Mohr <andi@lisas.de>
Cc: "David S. Miller" <davem@davemloft.net>, stable@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, dhollis@davehollis.com,
        Phil Chang <pchang23@sbcglobal.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -stable] Add USB PID for new MOSCHIP USB ethernet
 controller MCS7832 variant
Message-ID: <20101130202712.GB16171@suse.de>
References: <20101130200737.GA5185@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130200737.GA5185@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 09:07:37PM +0100, Andreas Mohr wrote:
> Due to active notification of the new MCS7832 version by the manufacturer
> today (Mr. Milton; thanks!) -- quote: "functionality same as MCS7830",
> I'm now submitting this patch, intended for networking.git and -stable.

This is not how you get stuff into the stable kernel trees, sorry.
Please read Documentation/stable_kernel_rules.txt for how to do that.

Sometimes I wonder why we even write documentation if no one ever reads
it...

thanks,

greg k-h

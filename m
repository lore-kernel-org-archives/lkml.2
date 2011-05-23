Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1EWQjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:39:05 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:61407 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab1EWQjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JtQ3umj7vhqrdSPTBAKGX4u67vhWh3bMjvB2KTSH229pYyGU6x5UTcz7Llczay4d3L
         zW+Wq8q8vhuDPrxbLPS3pJnwqCOFQ+Zjxci9Bw9XH6SEVGqfcISGCgRdm8o4K6H4M2I2
         tioynR0pqrcl30vUgfJgOjg0EBijrepv/XbxE=
Date: Mon, 23 May 2011 09:38:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: Resume Issues :Exec of NX page, Synaptics Botchup
Message-ID: <20110523163857.GA20397@core.coreip.homeip.net>
References: <alpine.DEB.2.02.1105221720040.2065@natty-nar>
 <BANLkTik9ZmQz1A0PBC4P-9XF-hB6Ywr3uQ@mail.gmail.com>
 <alpine.DEB.2.02.1105221817100.1868@natty-nar>
 <BANLkTimt0ozTCSarTVwkOpvgLoW-pizMvA@mail.gmail.com>
 <alpine.DEB.2.02.1105222258590.3372@natty-nar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1105222258590.3372@natty-nar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Parag,

On Sun, May 22, 2011 at 11:04:49PM -0400, Parag Warudkar wrote:
> 
> Problem solved - no more NX exec error and who knows how Synaptics is 
> working fine too - may be the exec after free scribbled something 
> somewhere that hurt Synaptics.

Please let me know if you see Synaptics reverting to PS2 mode after
resume again - it should not normally happen (there could be sometimes
flukes after resume but they should be detected and the kernel should
try re-initialize the touchpad completely instead of doing "reconnect").

Thanks.

-- 
Dmitry

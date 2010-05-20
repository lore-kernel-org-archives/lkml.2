Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0ETBNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:13:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49500 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0ETBNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vtxUQCKELbXFCg0R/VVEBdDDHMksPV2RZbb5+fplnMoCSvEO1DGP/qIR0ETCrgmkqs
         9l6Gshr4nYD95QhmtNbJHGx6KsqFb/c6SDaYaFmPf2LJI+Ugn2es2TgzucBd6POUPNx4
         73er76f6gevcwT6sE8Uv9C5gLKf1sUlBknUh0=
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
In-Reply-To: <20100519173449.6babbdfa@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
	 <20100519173449.6babbdfa@virtuousgeek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 04:13:03 +0300
Message-ID: <1274317983.2815.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 17:34 -0700, Jesse Barnes wrote: 
> On Fri, 9 Apr 2010 15:10:50 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > This set of 3 patches makes it a little more likely we'll get panic
> > output onto the screen even when X is running, assuming a KMS enabled
> > stack anyway.
> > 
> > It gets me from a blank or very sparsely populated black screen at
> > panic time, to one including the full backtrace and panic output at
> > panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> > session).
> > 
> > It doesn't cover every case; for instance I think it'll fail when X has
> > disabled the display, but those cases need to be handled with separate
> > patches anyway (need to add atomic DPMS paths for instance).
> > 
> > Anyway, please test these out and let me know if they work for you.
> 
> Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.
> 
Second that, just tested these patches, and these work perfectly.
One more reason for me to dump nvidia driver for nouveau.

Best regards,
Maxim Levitsky


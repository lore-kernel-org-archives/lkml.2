Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1LEVYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:24:14 -0500
Received: from shutemov.name ([188.40.19.243]:32925 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416Ab1LEVYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:24:12 -0500
Date: Mon, 5 Dec 2011 23:24:11 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Adam Jackson <ajax@redhat.com>, g@shutemov.name
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915: eDP regression
Message-ID: <20111205212411.GA20000@shutemov.name>
References: <20111203173508.GA15806@shutemov.name>
 <1323095835.5207.7.camel@atropine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323095835.5207.7.camel@atropine>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 09:37:15AM -0500, Adam Jackson wrote:
> On Sat, 2011-12-03 at 19:35 +0200, Kirill A. Shutemov wrote:
> > Hi,
> > 
> > Commit dc22ee6 introduces regression on my laptop HP EliteBook 8440p.  I see
> > nothing on the panel after mode setting. Reverting the commit fixes the issue.
> 
> Try this patch (might need rediffing):
> 
> http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg05889.html

Rediffing looks not trivial (hunk #2 of drivers/gpu/drm/i915/intel_dp.c).
Could you provide a patch?

-- 
 Kirill A. Shutemov

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2GEIdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:33:46 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:54757 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2GEIdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:33:43 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoxMAPpQ9U9V5qg+PGdsb2JhbABFihqtCRkBAQEBHgMWDSeCGAEBBTocEwEPEAgDGC4UJQoaExuHdLoSFIslhV5gA5U2hWaMf4FUIg
X-IronPort-AV: E=Sophos;i="4.77,530,1336341600"; 
   d="scan'208";a="74998643"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 5 Jul 2012 10:34:10 +0200
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION] nouveau: Memory corruption using nva3 engine for
 0xaf
Message-ID: <20120705083410.GA395@polaris.bitmath.org>
References: <1341469873-1582-1-git-send-email-rydberg@euromail.se>
 <20120705064049.GA8693@nisroch.bne.redhat.com>
 <20120705065446.GA1849@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705065446.GA1849@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:54:46AM +0200, Henrik Rydberg wrote:
> > Thanks for tracking down the source of this corruption.  I don't have
> > any such hardware, so until someone can figure it out, I think we
> > should apply this patch.
> 
> In that case, I would have to massage the patch a bit first; it
> creates a problem with suspend/resume. Might be something with
> nva3_pm.c, who knows. I am really stabbing in the dark here. :-)

It seems the suspend/resume problem is unrelated (bad systemd update),
so I am fine with applying this as is. Obviously not the best
solution, and if I have time I will continue to look for problems in
the nva3 copy code, but for now,

    Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

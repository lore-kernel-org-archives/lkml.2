Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0D1Odc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:33:32 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51089 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0D1Od3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:33:29 -0400
Date: Wed, 28 Apr 2010 15:32:11 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-fbdev@vger.kernel.org, arnaud.patard@rtp-net.org,
       jayakumar.lkml@gmail.com, gregkh@suse.de, yuasa@linux-mips.org,
       lethal@linux-sh.org, akpm@linux-foundation.org, adobriyan@gmail.com,
       support@simtec.co.uk, ben@simtec.co.uk, linux@simtec.co.uk,
       jkosina@suse.cz, pjones@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cocbalt_lcdfb: correct sections
Message-ID: <20100428143211.GA25641@linux-mips.org>
References: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 12:25:02PM +0200, Henrik Kretzschmar wrote:

> Since the drivers probe call was changed from .init.text
> to .devinit.text in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b
> the fb_fix_screeninfo structure must be
> changed from .init.data to .devinit.data, too.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
> It would be nice if someone with a MIPS gcc could test this patch and
> give me some feedback if it works the way it should, since atm I'm lacking
> a crosscompiler setup.

Works as advertised.

Tested-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf

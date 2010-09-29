Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0I2Ruf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:50:35 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44383 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0I2Rud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:50:33 -0400
Date: Wed, 29 Sep 2010 19:50:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: matt mooney <mfm@muteddisk.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Documentation/kbuild: correct variable definitions in
	makefiles.txt
Message-ID: <20100929175031.GA9278@merkur.ravnborg.org>
References: <1284964412-32211-1-git-send-email-mfm@muteddisk.com> <4CA35541.9090106@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA35541.9090106@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 05:03:29PM +0200, Michal Marek wrote:
> On 20.9.2010 08:33, matt mooney wrote:
> > Change $(src) and $(obj) definitions to state the path as absolute and
> > not relative.
> 
> It _is_ a relative patch, AFAICS. What makes you think otherwise?

With extenal modules $(src) and $(obj) are absolute - but in nomal use they are relative.
And again in normal use they are also equal. I usually say that we have two just to document
what is srource and what is generated.

	Sam

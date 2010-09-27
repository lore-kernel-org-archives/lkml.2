Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab0I0Ltx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:49:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:52934 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0I0Ltw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:49:52 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Date: Mon, 27 Sep 2010 13:49:48 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; i686; ; )
Cc: Valerie Aurora <vaurora@redhat.com>, linuxram@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, viro@zeniv.linux.org.uk
References: <20100920180404.939991832@szeredi.hu> <20100924175653.GB25129@shell> <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu>
In-Reply-To: <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271349.49077.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010 10:11:53 Miklos Szeredi wrote:
> [...] marking new directories opaque is only a half solution.
> E.g. consider the case when we have /a/b/c/ on the lower fs
> and /a/b/ on the upper, which is not opaque.  Then /a/b/c/ is created
> on the upper fs off-line.  The union logic can't notice that "c"
> should really be opaque and will merge with the contents of the lower
> layer.

I can think of arguments for either behavior, perhaps with a slight preference 
for your suggestion (default = opaque).

In any case, admins will need a way to flip opaque flags and remove undesired 
whiteouts.

Thanks,
Andreas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab1EOPkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:40:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53643 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab1EOPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=QzC+/MI34dSGBdqzjLgPc1cedVOLsB7LA5pr9xJZoLRdXmTHMtoEmPZUxpLDLepVBm
         BwgVzmaW1iyX/4ur+2oui/kFQx023ZIwj0z3vaqmjQrWS4ZbY7b2xp6+ob4UCx0ZuWYz
         VuJV/caG3P6PlUyfDmiVSm6Pu5rOMoeldBJJc=
Date: Sun, 15 May 2011 12:40:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: mfmooney@gmail.com
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] package: Makefile: fix perf target bug
Message-ID: <20110515154002.GB6274@ghostprotocols.net>
References: <4DCD8CE4.4090404@suse.cz>
 <b07e7ecdce48bc90a2cf83e8867494dae7cd174f.1305329845.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b07e7ecdce48bc90a2cf83e8867494dae7cd174f.1305329845.git.mfm@muteddisk.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 13, 2011 at 04:41:12PM -0700, mfmooney@gmail.com escreveu:
> From: matt mooney <mfm@muteddisk.com>
> 
> Specify --git-dir when building perf targets to allow out-of-tree
> builds using O=<build-dir>.
> 
> The shell command in `git archive' had to be modified to allow proper
> file name expansion of the files listed in MANIFEST.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>

Michal,

	Can I have your Reviewed-by or Acked-by for this one? Assuming
all is ok by now :)

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0HIJNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:13:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:33303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab0HIJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:13:12 -0400
Date: Mon, 9 Aug 2010 11:13:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH]Documentation update broken web addresses.
In-Reply-To: <4C596C75.9070505@gmail.com>
Message-ID: <alpine.LNX.2.00.1008091112320.29919@pobox.suse.cz>
References: <1279943484-31069-1-git-send-email-justinmattock@gmail.com> <4C547464.6000505@gmail.com> <alpine.LNX.2.00.1008041521480.29919@pobox.suse.cz> <4C596C75.9070505@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Justin P. Mattock wrote:

> > I have now applied it. Please keep in mind, for your future submissions,
> > to make sure that you handle UTF-8 correctly. I had to manually fix your
> > patch for files in Japaneese, Korean and Chineese languages.
> > 
> > Thanks,
> > 
> 
> thanks!!
> yeah I did see those where churned up, but couldnt figure out why sending
> individually the language came out fine, but with the whole lot the churn
> would happen.
> 
> just to make sure there was a change(not sure if you received my previous
> post) with an address at:
> 
> Documentation/filesystems/affs.txt
> (https://patchwork.kernel.org/patch/113264/)
> 
> this address seems to be a better location
> http://www.amigaemulator.org/
> 
> wanted to wait until if I received other such changes before resending again,
> but it's too late it's already applied

The patch is already in Linus' tree, so if there are any changed that 
should be applied on top of your previous patch, please send them my way.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0I2OhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:37:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0I2OhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:37:05 -0400
Message-ID: <4CA34F0B.6010605@suse.cz>
Date: Wed, 29 Sep 2010 16:36:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: matt mooney <mfm@muteddisk.com>
Cc: Greg Ungerer <gerg@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 08/20] m68knommu: change to new flag variables
References: <1285224645-29728-1-git-send-email-mfm@muteddisk.com> <4CA18E00.7090207@snapgear.com> <20100928071606.GA13303@haskell.muteddisk.com>
In-Reply-To: <20100928071606.GA13303@haskell.muteddisk.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.9.2010 09:16, matt mooney wrote:
> My original intent was through the maintainer trees; however, I am starting to
> realize that it probably would have been best to all go into the kbuild tree as
> one patch series. That being said, some people have picked them up and others
> have just acked, so really whatever is easiest for you. All unapplied will
> eventually go through the kbuild tree.

Please try push as much through maintainer trees as possible, to avoid
unnecessary merge conflicts. Of course, if you end up with some patches
that nobody is picking up, I'll apply them to the kbuild tree.

Thanks,
Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab2LQKOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:14:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2LQKOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:14:34 -0500
Message-ID: <50CEF080.8010208@suse.cz>
Date: Mon, 17 Dec 2012 11:14:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
References: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1355523576-7596-1-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.12.2012 23:19, Cesar Eduardo Barros wrote:
> This small script checks the file patterns in the MAINTAINERS file.
> 
> For every file pattern, it checks if the pattern matches any file or
> directory in the kernel tree, printing the patterns which do not have a
> match.

Can't this be added as a warning to scripts/get_maintainer.pl instead?

Thanks,
Michal

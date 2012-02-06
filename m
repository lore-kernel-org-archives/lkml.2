Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2BFQQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:16:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54635 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2BFQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:16:34 -0500
Date: Mon, 6 Feb 2012 11:07:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: hauke@hauke-m.de, kernel-team@lists.ubuntu.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
Message-ID: <20120206160727.GA21048@tuxdriver.com>
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 03:43:14PM -0800, Luis R. Rodriguez wrote:
> This adds get-compat-kernels, a utility that is intended
> to be Linux distribution agnostic that downloads and installs
> all kernel headers for all supported kernel releases of compat.
> You also have the option of specifying you want to also install
> the actual kernel image (get-compat-kernels -i).
> 
> We start off by adding support for Ubuntu on x86_64 as that
> is what a few of us maintaining compat and compat-wireless run.
> Just for kernel headers (default run of get-compat-kernels),
> you'll need currently 205 M of hard drive space.
> 
> Once done with running get-compat-kernels, you can then
> start running ckmake to verify your compat kernel changes
> won't bust compilation against any known supported kernel.
> 
> I'd like to start requiring runs against this script for
> patch submissions. Eventually we can try to add the same
> runs against compat-wireless so we can verify integrity
> against compilation for different kernel versions.
> 
> Support for different Linux distributios is welcomed.
> 
> Debug log goes out to ckmake.log
> 
> Example output:
> 
> mcgrof@tux ~/compat (git::master)$ ckmake
> Trying kernel                  3.3.0-030300rc2-generic  [OK]
> Trying kernel                     3.2.2-030202-generic  [OK]
> Trying kernel                    3.1.10-030110-generic  [OK]
> Trying kernel                    3.0.18-030018-generic  [OK]
> Trying kernel                  2.6.39-02063904-generic  [OK]
> Trying kernel                         2.6.38-8-generic  [OK]
> Trying kernel                        2.6.38-13-generic  [OK]
> Trying kernel                        2.6.38-12-generic  [OK]
> Trying kernel                        2.6.38-11-generic  [OK]
> Trying kernel                        2.6.38-10-generic  [OK]
> Trying kernel                  2.6.38-02063808-generic  [OK]
> Trying kernel                  2.6.37-02063706-generic  [OK]
> Trying kernel                  2.6.36-02063604-generic  [OK]
> Trying kernel                  2.6.35-02063512-generic  [OK]
> Trying kernel                  2.6.34-02063410-generic  [OK]
> Trying kernel                  2.6.33-02063305-generic  [OK]
> Trying kernel                  2.6.32-02063255-generic  [OK]
> Trying kernel                        2.6.31-22-generic  [OK]
> Trying kernel                  2.6.31-02063113-generic  [OK]
> Trying kernel                  2.6.30-02063010-generic  [OK]
> Trying kernel                  2.6.29-02062906-generic  [OK]
> Trying kernel                  2.6.28-02062810-generic  [OK]
> Trying kernel                    2.6.27-020627-generic  [OK]
> Trying kernel                    2.6.26-020626-generic  [OK]
> Trying kernel                    2.6.25-020625-generic  [OK]
> Trying kernel                    2.6.24-020624-generic  [OK]
> 
> Cc: kernel-team@lists.ubuntu.com
> Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>

I'm not sure this makes any sense.  I thought the point of the compat
project was to support upstream kernels, not distro ones?  I'm not
even sure I know how to replicate the above process in Fedora, since
we would only have kernels available from a given release in each
release's repository.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

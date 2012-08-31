Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2HaOSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:18:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2HaOSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:18:02 -0400
Date: Fri, 31 Aug 2012 16:18:00 +0200
From: Michal Marek <mmarek@suse.cz>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        sam@ravnborg.org, artem.bityutskiy@linux.intel.com
Subject: Re: [PATCH] kbuild: Remove useless warning while appending KCFLAGS
Message-ID: <20120831141800.GB11531@sepie.suse.cz>
References: <1344960054-26557-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344960054-26557-1-git-send-email-ozancag@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 07:00:54PM +0300, Ozan Çağlayan wrote:
> This is a respin of an older patch sent by Sam Ravnborg:
>   http://www.gossamer-threads.com/lists/linux/kernel/1530602
> 
> This patch removes the annoying warning:
> 
> Makefile:708: "WARNING: Appending $KCFLAGS (-Wno-sign-compare) from command
> line to kernel $CFLAGS"
> 
> which is printed every time I use KCFLAFS. The commit which introduced the
> warning:
> 
> 69ee0b3 kbuild: do not pick up CFLAGS from the environment
> 
> tells about the problems when people have CFLAGS in their environment,
> then switches to KCFLAFS which should be enough to solve the issue, but
> it anyway introduces a warning. Drop this warning.
> 
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Thanks, applied to kbuild.git#kbuild.

Michal

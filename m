Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2CZUXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:23:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab2CZUXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:23:08 -0400
Date: Mon, 26 Mar 2012 22:23:06 +0200
From: Michal Marek <mmarek@suse.cz>
To: Yang Bai <hamo.by@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, rostedt@goodmis.org,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts: refactor remove structure forward declarations
Message-ID: <20120326202306.GA10259@sepie.suse.cz>
References: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
 <4F5E32F2.5030000@codeaurora.org>
 <CAO_0yfMUA6zD4PkUVwdnfjNMXdz-=Fy1GQZjj2N83MKDKzRwiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_0yfMUA6zD4PkUVwdnfjNMXdz-=Fy1GQZjj2N83MKDKzRwiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 03:05:47PM +0800, Yang Bai wrote:
> Ping.
> 
> cc linux-kbuild
> 
> On Tue, Mar 13, 2012 at 1:31 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > On 03/12/12 01:20, Yang Bai wrote:
> >> Since now it has some problems when generate TAGS,
> >> refactor this code. Now it will not show the error
> >> message and will remove declarations using emacs etags.
> >>
> >> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> >
> > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Applied to kbuild.git#misc.

Michal

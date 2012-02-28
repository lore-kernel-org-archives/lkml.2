Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab2B1JTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:19:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52742 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2B1JTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:19:13 -0500
Date: Tue, 28 Feb 2012 01:19:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Armando Visconti <armando.visconti@st.com>,
        Viresh Kumar <viresh.kumar@st.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 27 (usbtouchscreen)
Message-ID: <20120228091907.GA20034@core.coreip.homeip.net>
References: <20120227182029.545a7db32550ce94c9faffb4@canb.auug.org.au>
 <4F4BC717.1000304@xenotime.net>
 <4F4BF7E2.3080203@gmx.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4BF7E2.3080203@gmx.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 10:38:42PM +0100, Daniel Ritz wrote:
> On 2012-02-27 19:10 , Randy Dunlap wrote:
> > On 02/26/2012 11:20 PM, Stephen Rothwell wrote:
> > 
> >> Hi all,
> >>
> >> Changes since 20120224:
> > 
> > 
> > 
> > on x86_64:
> > 
> > drivers/input/touchscreen/usbtouchscreen.c:1232:18: error: 'usbtouch_process_multi' undeclared here (not in a function)
> > 
> > 
> > Full randconfig file is attached.
> > 
> 
> Hi
> 
> I had a quick look with gitweb. The following change causes the problem, comments inline:
> 
> > From: Armando Visconti <armando.visconti@st.com>
> > Date: Fri, 24 Feb 2012 08:51:37 +0000 (-0800)
> > Subject: Input: usbtouchscreen - add support for Data Modul EasyTouch TP 72037
> > X-Git-Tag: next-20120227~55^2~4
> > X-Git-Url:
> http://git.kernel.org/gitweb.cgi?p=linux%2Fkernel%2Fgit%2Fnext%2Flinux-next.git;a=commitdiff_plain;h=e6307aa07c5a11022f0ccee19a8ff0ba033eeb93
> >
> > Input: usbtouchscreen - add support for Data Modul EasyTouch TP 72037
> >
> > The Data Modul TP 72037 EasyTouch controller is derived from EGALAX
> > controller and is capable of detecting dual contacts. Packets can be 5
> > bytes or 10 bytes long, depending whether one or two contacts are
> > detected. Format is same as EGALAX touch controller, but with x and y
> > coordinates inverted.
> >
> > Signed-off-by: Armando Visconti <armando.visconti@st.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Sorry about this, I'll drop the patch for now.

Thanks.

-- 
Dmitry

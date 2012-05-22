Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab2EVTEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:04:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64868 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2EVTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:04:39 -0400
Date: Tue, 22 May 2012 12:04:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: devel@driverdev.osuosl.org, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>, arve@android.com,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH v4 0/16] Merge ram_console into pstore, and more
Message-ID: <20120522190433.GA29404@kroah.com>
References: <20120522141717.GA31574@lizard>
 <20120522181910.GA28826@kroah.com>
 <CAGXu5jJcHDWOf4Kgnz45CT0ud-zMr2SERL2ogjeJC6n64+pQZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJcHDWOf4Kgnz45CT0ud-zMr2SERL2ogjeJC6n64+pQZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:33:33AM -0700, Kees Cook wrote:
> On Tue, May 22, 2012 at 11:19 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, May 22, 2012 at 07:17:17AM -0700, Anton Vorontsov wrote:
> >> Hi all,
> >>
> >> A brand new v4:
> >>
> >> - Per Kees Cook's comments, the patches no longer remove an automatic
> >>   updates feature, but instead make the it configurable; plus disable
> >>   it by default (in a separate patch);
> >> - Fixed some bugs noticed by Colin Cross;
> >> - Documented new continuous ramoops-console log behaviour (also
> >>   noticed by Colin Cross).
> >
> > In case you were wondering, all of this is going to have to wait for
> > 3.6, as the 3.5 merge window with my trees have been closed.  I'll be
> > able to start accepting patches once 3.5-rc1 is out, so take your time
> > in getting this all working properly, there's no rush here.
> 
> Will the ramoops stuff that was in -next (via -mm) that now landed in
> -staging make it sanely into 3.5? Specifically the two patches at the
> top of:
> http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/ramoops

Anything that was in staging and linux-next already, yes, will go in for
3.5, I've already sent Linus the pull request for that.

Is that a problem?

thanks,

greg k-h

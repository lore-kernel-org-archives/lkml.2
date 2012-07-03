Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2GCQtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:49:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51244 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2GCQtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:49:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: linux-next : cpuidle - could you add my tree please
Date: Tue, 3 Jul 2012 18:54:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        "Lists Linaro-dev" <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>, "lenb@kernel.org" <lenb@kernel.org>
References: <4FDEE98D.7010802@linaro.org> <20120703231948.33cca18e3cc3d6e497ab022d@canb.auug.org.au> <4FF2F2D3.4090200@linaro.org>
In-Reply-To: <4FF2F2D3.4090200@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031854.51163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 03, 2012, Daniel Lezcano wrote:
> On 07/03/2012 03:19 PM, Stephen Rothwell wrote:
> > Hi Daniel,
> > 
> > On Tue, 03 Jul 2012 14:56:58 +0200 Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> >>
> >>> So do you have a branch in the cpuidle-next.git tree that isn't going to
> >>> be rebased?
> >>
> >> No. I am following Linus tree and adding the patches on top of it.
> > 
> > Please don't rebase your tree more than necessary - it just makes thing
> > hard for anyone using your tree as a base for further development and
> > throws away any testing you may have done.
> 
> Ok, let me sync with Len and Rafael about the best way to do that.

Please create a branch in your tree for me to pull from and let me know
which one it is.  Please note that this branch must not be rebased after I've
pulled from it and it's going to be included into my linux-next branch
automatically.

I'll include it into my v3.6 push, because I have a couple of cpuidle patches
queued up already.  We'll need to discuss the future of it after 3.6, though.

Thanks,
Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2HJCnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:43:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:15751 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2HJCnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:43:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,743,1336374000"; 
   d="scan'208";a="132208466"
Message-ID: <1344566688.1682.711.camel@rui.sh.intel.com>
Subject: Re: thermal patches in linux-next
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Amit Kachhap <amit.kachhap@linaro.org>, Guenter Roeck <linux@roeck-us.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Date: Fri, 10 Aug 2012 10:44:48 +0800
In-Reply-To: <20120810122355.8d6429ac84aa26d296a89e7b@canb.auug.org.au>
References: <1344308038.1682.637.camel@rui.sh.intel.com>
	 <1344494746.1682.669.camel@rui.sh.intel.com>
	 <20120810090859.7ec67594f794c38c52096544@canb.auug.org.au>
	 <1344562866.1682.698.camel@rui.sh.intel.com>
	 <20120810122355.8d6429ac84aa26d296a89e7b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2012-08-10 at 12:23 +1000, Stephen Rothwell wrote:
> Hi Rui,
> 
> On Fri, 10 Aug 2012 09:41:06 +0800 Zhang Rui <rui.zhang@intel.com> wrote:
> >
> > > > And could you please drop these commits
> > > > ef25a0fe0087963c1611c1c8903886fbea053f76
> > > > 09ec52fca274ba88d68df3198de92abdaaff417b
> > > > ab6d2f029358c917508bf88bbd6a9193a8e39fc8
> > > > 66447fa993cbce56b4076f169a56f62350f6c7b8
> > > > ec62abb8b46021ca9ee6b8692b26974ace9007f0
> > > > 5ecbaf57d7885eedd924e391d91847d3df9fe0f8
> > > > 851414b2249afd8c128d29912dfd7060eaea8932
> > > > and pull my next branch instead?
> > > 
> > > That is not how linux-next normally works.  Those commits are in Adnrew's
> > > quilt series, so you need to ask him to drop them.  However, because of
> > > the way the akpm tree works, any duplicate patches will disappear from my
> > > copy of Andrew's series.
> > 
> > could you please drop these patches?
> > these commits either will be or has been re-based on top of my tree.
> 
> You should always quote the summary line of commits.  Andrew is using
> quilt to manage his patches and so those commit ids mean nothing to him
> (and they have changed in today's linux-next anyway).
> 
got it.

Andrew,
could you please drop these patches from Amit for now?

ARM: exynos: add thermal sensor driver platform data support
thermal: exynos: register the tmu sensor with the kernel thermal layer
thermal: exynos5: add exynos5 thermal sensor driver support
hwmon: exynos4: move thermal sensor driver to driver/thermal directory
thermal: add generic cpufreq cooling implementation

these patches can not build because of the recent thermal changes, and
Amit agreed with me to re-base them on top of my tree.

thanks,
rui


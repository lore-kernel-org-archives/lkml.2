Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1CHQ1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:27:10 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:52814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1CHQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:27:07 -0500
Subject: Re: 2.6.38-rc7, iwlagn warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinj1f0Kx5X6eqYEdyzT_3XLbtbLtwbp7jPN2LSH@mail.gmail.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	 <20110304134648.GB9866@tuxdriver.com>
	 <1299251879.24333.3.camel@wwguy-ubuntu>
	 <AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	 <AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	 <AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
	 <1299334144.3826.8.camel@jlt3.sipsolutions.net>
	 <AANLkTikQHUq95e9=3tG5WrayaxUu+K1FdAftJ3y72BTn@mail.gmail.com>
	 <1299597447.4676.25.camel@jlt3.sipsolutions.net>
	 <AANLkTinj1f0Kx5X6eqYEdyzT_3XLbtbLtwbp7jPN2LSH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 17:26:59 +0100
Message-ID: <1299601619.3734.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 16:22 +0000, Mathias Burén wrote:

> > Would you be willing to enable tracing and capture a trace using
> > trace-cmd, by running 'trace-cmd record -e mac80211 -e iwlwifi'?

> I've since upgraded to 2.6.38-rc8 (same config). Looking around in the
> config, is it CONFIG_FUNCTION_TRACER I need to enable, and is that it?
> (kernel function tracer)

You need CONFIG_MAC80211_DRIVER_API_TRACER and
CONFIG_IWLWIFI_DEVICE_TRACING (and their prerequisites, which you can
find in menuconfig by hitting the slash ("/") key and searching for
these config symbols, remove the CONFIG_ prefix)

johannes


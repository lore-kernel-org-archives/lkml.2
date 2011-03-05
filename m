Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1CEOJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:09:13 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:38108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CEOJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:09:12 -0500
Subject: Re: 2.6.38-rc7, iwlagn crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	 <20110304134648.GB9866@tuxdriver.com>
	 <1299251879.24333.3.camel@wwguy-ubuntu>
	 <AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	 <AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	 <AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 15:09:04 +0100
Message-ID: <1299334144.3826.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 09:45 +0000, Mathias Burén wrote:

> I compiled my own kernel (downloaded 2.6.37-rc8 source, applied the
> apparmor patch required for Ubuntu, copied over the config, make
> oldconfig, enabled iwlwifi debug in menuconfig then compiled it),
> booted it and loaded iwlagn with debug=0x43fff. Then I attempted the
> same thing (Ubuntu Adhoc, no wireless security, trying to connect with
> the phone).
> 
> The entire dmesg can be found here:
> http://www.privatepaste.com/download/49e6ead6c7

So the warning is gone now?

johannes


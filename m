Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2L2IVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 03:21:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64289 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2L2IVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 03:21:18 -0500
Date: Sat, 29 Dec 2012 00:21:12 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 024/173] drm/i915: add Ivy Bridge GT2 Server entries
Message-ID: <20121229082112.GE18903@elie.Belkin>
References: <20121228190330.025298996@decadent.org.uk>
 <20121228190335.033137454@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228190335.033137454@decadent.org.uk>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> This adds PCI ID for IVB GT2 server variant which we were missing.

As discussed at [1], this triggers a small regression with Debian
wheezy userspace (X freezing instead of erroring out).  libdrm hasn't
been updated in wheezy since then, and I wouldn't be surprised if
other distros were affected, too.  Has there been a kernel patch since
then to avoid that?

Though I wouldn't mind seeing this applied anyway, FWIW, as long as
the announcement mentions the userspace bugfix needed.

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.debian.devel.bugs.general/978320/focus=74843

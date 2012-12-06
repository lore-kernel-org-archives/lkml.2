Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2LFQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:24:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2LFQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:24:07 -0500
Date: Thu, 6 Dec 2012 17:24:02 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Lekensteyn <lekensteyn@gmail.com>, Heinz Diehl <htd@fritha.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121206162402.GA2042@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <1498848.rM1KKK5er8@al>
 <20121204210845.GA2092@fritha.org>
 <2102240.hdkK7C4k4g@al>
 <CAKMK7uEaT1H0DUszYqxbp_8WdLWs2quQbSJVqir0eAibYKvN+A@mail.gmail.com>
 <20121206093544.GA22915@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206093544.GA22915@fancy-poultry.org>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:J7vfFVMY08ZhEaInQW9+1QNEzJhjVfBIKUAiC0v4jCW
 +l14zI552E6Z1rASWYm1sWAUoQwYiT5IORfb/2JwLHcUWZurL9
 bWgdg8mX5YTw6NoIXnZbdH5XrAM/NZJuAISRoOpXJQmFESyKDU
 L31OW4jAz73fMaKWV30ITsxdys26GAGwDq7TXvg49ob1KeMWhm
 PqQnx0M1OgNzemFKxzvifLIyJlUS0pDUsS1ENN+UPGWc7+TwGw
 sFBRTsd7DCvOULmzWm75d5UgAERO3ci5QmkMSOlXP8Kj+JNgVD
 wsXxlu60dXf92KfAhjFWrv9DzaL2e+N6xM5TxnXBsvIfjd8+Ro
 RAKvXf+qsPSF+H95Sya2aVmP3SLaIUZs9Re/C8GYM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2012, Heinz Diehl wrote: 

[....]

Here are some more error-logs, inkl. dmesg after booting with drm
debug options turned on:

http://www.fritha.org/i915/gpu-hang.tar.bz2


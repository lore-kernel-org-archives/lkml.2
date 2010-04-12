Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0DLVWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:22:07 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:42918 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0DLVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:22:06 -0400
Date: Mon, 12 Apr 2010 14:22:03 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Cc: Ben Kseggs <bskeggs@redhat.com>, Dave Airlie <airlied@linux.ie>
Subject: nouveau userspace bits for 2.6.34
Message-ID: <20100412212203.GA2671@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:18:03AM -0800, Linus Torvalds wrote:
> 	(II) NOUVEAU(0): [drm] nouveau interface version: 0.0.16
> 	(EE) NOUVEAU(0): [drm] wrong version, expecting 0.0.15
> 	(EE) NOUVEAU(0): 879:

So I've tried reading the thread and haven't found the answer to this
question yet; my apologies for surely missing the answer which is out
there.

What version of libdrm-nouveau and xserver-xorg-video-nouveau do I need
in order to run nouveau on 2.6.34-rc3 and later?

What git branches should I be tracking?  What changesets add support for
nouveau interface version 0.0.16?

(I'm on Debian and Ubuntu, but building my own from git is fine.)

Thanks,
-andy

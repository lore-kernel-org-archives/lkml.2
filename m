Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab0EABGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:06:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42313 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab0EABGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:06:38 -0400
Message-ID: <4BD95021.7010306@canonical.com>
Date: Thu, 29 Apr 2010 10:23:45 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: [ANNOUNCE] linux-2.6.32.y-drm33.z
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As many of us now have a distribution which is based on a 2.6.32 kernel but are
forced to update DRM to the version in 2.6.33 to obtain good graphics
experience. In support of this I went ahead and created a tree on kernel.org[1]
which brings together the two and which I will maintain following the upstream
stable trees from Greg. This hopefully will not only be beneficial to us but
also to all that are in the need of running this combination of code.

-Stefan

[1] http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git

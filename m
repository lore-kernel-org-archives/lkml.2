Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894Ab1BYFBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:01:06 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:50627 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1BYFBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:01:05 -0500
Message-ID: <4D67378C.30506@msgid.tls.msk.ru>
Date: Fri, 25 Feb 2011 08:01:00 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <4D671667.4000602@suse.com>
In-Reply-To: <4D671667.4000602@suse.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.02.2011 05:39, Jeff Mahoney wrote:
>  Every kernel package trying to provide files under /lib/firmware runs
>  into problems really quickly with multiple kernels installed.

Which problems?

>  This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
>  firmware.sh looks there first before falling back to /lib/firmware.

This was the way it worked before, -- all fw in kernel-specific dir.
Nowadays it moved to a common place, /lib/firmware, since the blobs
there are not kernel-specific but hardware-specific.  And now you
propose to move it back.  Why?

/mjt

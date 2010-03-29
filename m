Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0C2QiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:38:10 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:48111 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754154Ab0C2QiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:38:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lM6u6t3sE/YU4k8xaIwqojvifzP11p1saxpBnqt2kMw5Ah/3G29TPsX7Uuck/2nbPZjLf6KOipD1gWgfWz3xkp+/isJZYwLDe1vDLGqCnY8HKCMEFtPpnwYYDvfh3d/z;
Date: Mon, 29 Mar 2010 09:37:02 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU
 hung)
Message-ID: <20100329093702.65a2f1f9@jbarnes-piketon>
In-Reply-To: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
References: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Mar 2010 01:11:05 +0900
Norbert Preining <preining@logic.at> wrote:

> Dear all,
> 
> (please Cc)
> 
> I am running 2.6.34-rc2 + git 01e7770 commit (yesterday) with KMS on Debian/sid:
> xserver-xorg: 7.5+5
> video-intel: 2.9.1-3
> 
> Running D2X-xl (self compiled) (descent2 open source code) X suddenly died,
> and after that gdm could not be restarted because after a few secs
> it went dead again.
> 
> In the logs I see:
> kernel: [ 2486.341227] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> kernel: [ 2486.341240] render error detected, EIR: 0x00000000
> kernel: [ 2486.341278] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113671 at 113604)
> kernel: [ 2486.669008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> kernel: [ 2486.669012] render error detected, EIR: 0x00000000
> kernel: [ 2486.669522] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113672 at 113604)
> kernel: [ 2487.524230] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> kernel: [ 2487.524243] render error detected, EIR: 0x00000000
> kernel: [ 2487.524284] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113673 at 113604)
> kernel: [ 2487.912237] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> kernel: [ 2487.916175] render error detected, EIR: 0x00000000
> kernel: [ 2487.920137] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113674 at 113604)
> 
> Stopping gdm and restarting didn't help to get the graphics card back to normal.
> 
> If you have any ideas how to fix/track/debug that please let me know,
> same if you need more information.

I was seeing something similar on my 945, can you try this patchset?
It seems to make things much more stable for me.

http://lists.freedesktop.org/archives/intel-gfx/2010-March/006387.html

There are 7 patches starting with that one.

-- 
Jesse Barnes, Intel Open Source Technology Center

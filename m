Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0C3N5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:57:11 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40684 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0C3N5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:57:09 -0400
Date: Tue, 30 Mar 2010 22:57:06 +0900
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU
	hung)
Message-ID: <20100330135706.GA27958@gamma.logic.tuwien.ac.at>
References: <20100327161104.GA12043@gamma.logic.tuwien.ac.at> <20100329093702.65a2f1f9@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100329093702.65a2f1f9@jbarnes-piketon>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 29 Mär 2010, Jesse Barnes wrote:
> I was seeing something similar on my 945, can you try this patchset?

Tried it with git kernel commit b72c409 and your patches, but
didn't change anything. Starting d2x-xl killed the X server:
[ 1067.920246] render error detected, EIR: 0x00000000
[ 1067.920293] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 48294 at 48216)
[ 1068.412095] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[ 1068.412107] render error detected, EIR: 0x00000000
[ 1068.412135] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 48299 at 48216)
[ 1068.776229] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung

Anything else I could try?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
PAPPLE (vb.)
To do what babies do to soup with their spoons.
			--- Douglas Adams, The Meaning of Liff

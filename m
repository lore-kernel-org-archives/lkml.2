Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0ENEWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:22:38 -0400
Received: from cobra.newdream.net ([66.33.216.30]:40580 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0ENEWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:22:36 -0400
Date: Thu, 13 May 2010 21:25:45 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cheng Renquan <crquan@gmail.com>
Subject: Re: linux-next: manual merge of the ceph tree with Linus' tree
In-Reply-To: <20100514100747.42445cdf.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1005132124170.25892@cobra.newdream.net>
References: <20100514100747.42445cdf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, 14 May 2010, Stephen Rothwell wrote:
> Hi Sage,
> 
> Today's linux-next merge of the ceph tree got a conflict in
> fs/ceph/super.c between commit 5dfc589a8467470226feccdc50f1b32713318e7b
> ("ceph: unregister bdi before kill_anon_super releases device name") from
> Linus' tree and commits 9f2a2a1faa0fd990d4930605583a67d7dff28bff ("ceph:
> use ceph_sb_to_client instead of ceph_client") and
> c72b09ba224e6f2c00bcf810a0a62059fcf405f7 ("ceph: name bdi ceph-%d instead
> of major:minor") from the ceph tree.

Aie, sorry...  I rebased everything queued for the next window yesterday 
but forgot to update the for-next tag.  These conflicts should all 
disappear next time around.

Thanks!
sage

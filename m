Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2C1Hn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:43:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44058 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2C1Hn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <4F72BB7F.8080704@gmail.com>
References: <CAB=NE6WgTMdDtU4_ZgYVr2XzSuiicT5o=q2RvV24jeQj0rZfFw@mail.gmail.com>
 <4F72BB7F.8080704@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 28 Mar 2012 00:43:36 -0700
X-Google-Sender-Auth: fUtG4JS80p4vxh8uV8yh1Ne-GD4
Message-ID: <CAB=NE6WFM-BPQ41kPaod-7qkHnT5MXCUc2hdKXDVzrdPq2brjA@mail.gmail.com>
Subject: Re: compat-wireless releases based on v3.3
To: Richard Farina <sidhayn@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org, lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:19 AM, Richard Farina <sidhayn@gmail.com> wrote:
> /var/tmp/portage/net-wireless/compat-wireless-3.3/work/compat-wireless-3.3-1-n/drivers/net/wireless/ath/carl9170/tx.c:
> In function 'carl9170_tx_ps_drop':
> /var/tmp/portage/net-wireless/compat-wireless-3.3/work/compat-wireless-3.3-1-n/drivers/net/wireless/ath/carl9170/tx.c:1248:26:
> error: 'IEEE80211_TX_CTL_POLL_RESPONSE' undeclared (first use in this
> function)

linux-next-cherry-picks/0007-mac80211-handle-non-bufferable-MMPDUs-correctly.patch

is to be blamed for. This is fixed, new tarball:

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.3/compat-wireless-3.3-2-n.tar.bz2
sha1sum: dd18cfabbe705a75440fd7fbe50a09d5fe34bb70

Thanks for reporting this. Just FYI -- I am working to use ckmake on
compat-wireless.git to build test against all supported kernels prior
to release just as I am doing now for compat.git, but the current
development cycle still a few items which require a bit of work to
backport to fix compilation against older kernels. That is the goal
though, so that future releases area always guaranteed to compile
against all supported stable kernel releases listed on kernel.org.

  Luis

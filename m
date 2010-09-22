Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0IVB4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:56:46 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:39007 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0IVB4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:56:45 -0400
Date: Tue, 21 Sep 2010 18:56:02 -0700
From: matt mooney <mfm@muteddisk.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: Make CFLAGS explicit
Message-ID: <20100922015602.GB12118@haskell.muteddisk.com>
Mail-Followup-To: Tim Gardner <tim.gardner@canonical.com>, gregkh@suse.de,
	linux-kernel@vger.kernel.org, Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:20 Fri 17 Sep     , Tim Gardner wrote:
> -EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
> +EXTRA_CFLAGS := -DBCMDBG -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes

Also, since you are changing this file, you should use ccflags-y instead of the
deprecated EXTRA_CFLAGS.

Thanks,
mfm

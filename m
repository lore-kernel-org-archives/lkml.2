Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1HRFYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:24:07 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:33751 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1HRFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:24:04 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: gaowanlong@cn.fujitsu.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
In-Reply-To: <4E4C80A0.8090708@cn.fujitsu.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <4E4C80A0.8090708@cn.fujitsu.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 13:26:13 +0800
Message-ID: <87d3g347ey.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanlong Gao,

On Thu, 18 Aug 2011 11:01:52 +0800, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> On 08/18/2011 09:57 AM, JJ Ding wrote:
> > v3 hardware's packet format is almost identical to v2 (one/three finger touch),
> > except when sensing two finger touch, the hardware sends 12 bytes of data.
> >
> > Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
> > ---
> >   Documentation/input/elantech.txt |  104 ++++++++++++++++--
> >   drivers/input/mouse/elantech.c   |  218 ++++++++++++++++++++++++++++++++++---
> >   drivers/input/mouse/elantech.h   |   11 ++
> >   3 files changed, 303 insertions(+), 30 deletions(-)
> >
> > +static int determine_packet_v3(struct psmouse *psmouse)
> elantech_check_parity_v1
> packet_simple_check_v2
> determine_packet_v3
> 
> Why not consistent them?
OK, how do these names sound to you?

elantech_check_parity_v1
elantech_packet_check_v2
elantech_packet_check_v3

Thanks,
jj

> -- 
> Thanks
> Wanlong Gao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

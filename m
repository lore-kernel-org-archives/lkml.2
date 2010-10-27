Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080Ab0J0M24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:28:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53208 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab0J0M2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <1288180057-19656-1-git-send-email-jslaby@suse.cz>
References: <1288180057-19656-1-git-send-email-jslaby@suse.cz>
Date: Wed, 27 Oct 2010 08:28:51 -0400
Message-ID: <AANLkTimEwyt-BdR9C8Vni-bsp4tbQ-Zs6A1CeMamapzz@mail.gmail.com>
Subject: Re: [PATCH 1/4] V4L: cx231xx, fix lock imbalance
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Devin Heitmueller <dheitmueller@hauppauge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 7:47 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Stanse found that there is mutex_lock in a fail path of
> cx231xx_i2c_xfer instead of mutex_unlock (i.e. double lock + leaving a
> function in locked state). So fix that.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Devin Heitmueller <dheitmueller@hauppauge.com>

This was already reported and a patch was submitted by Dan Carpenter
on October 21.  See mail on that day with subject line:  "[patch]
V4L/DVB: cx231xx: fix double lock typo".

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

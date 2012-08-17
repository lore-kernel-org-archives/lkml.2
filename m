Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2HQI15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:27:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40832 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2HQI1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:27:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120817074644.GL4559@mwanda>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
	<1345179920-8303-1-git-send-email-yamanetoshi@gmail.com>
	<20120817074644.GL4559@mwanda>
Date: Fri, 17 Aug 2012 17:27:53 +0900
Message-ID: <CAOTypNS_rbQK2rPDWenFahiz5Z+cufPTjRy-aABqW01c3DWmYQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging/vme: fix checkpatch warning
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 4:46 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> You've got the same subject repeated 5 times.
>
> It would be better to merge all the vme_user.c printk fixes into
> one patch.
> [patch 1/3] Staging: vme: Fix a white space issue
> [patch 2/3] Staging: vme: Use pr_ printks in vme_user.c
> [patch 3/3] Staging: vme: Use pr_ printks in vme_pio2_core.c
>
> It's not a huge deal, it just seems like there was some confusion on
> how to break patches up.


Thanks for your reply!
I will try to fix it.



-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com

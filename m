Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab2DIF4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 01:56:14 -0400
Received: from void.printf.net ([89.145.121.20]:42417 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab2DIF4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 01:56:12 -0400
From: Chris Ball <cjb@laptop.org>
To: "Hebbar\, Gururaja" <gururaja.hebbar@ti.com>
Cc: "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chuanxiao.dong\@intel.com" <chuanxiao.dong@intel.com>,
        "rjw\@sisk.pl" <rjw@sisk.pl>
Subject: Re: [GIT PULL] MMC fixes for 3.4-rc2
References: <87mx6o3b7d.fsf@laptop.org>
	<1BAFE6F6C881BF42822005164F1491C331827827@DBDE01.ent.ti.com>
Date: Mon, 09 Apr 2012 01:55:56 -0400
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C331827827@DBDE01.ent.ti.com>
	(Gururaja Hebbar's message of "Mon, 9 Apr 2012 05:36:18 +0000")
Message-ID: <87d37hzbwz.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 09 2012, Hebbar, Gururaja wrote:
> Hi,
>
> Is the pull already completed?

Yes, and -rc2 has already been released.

> If not can you add the recent mmc suspend/resume fix patch .
>
> http://www.spinics.net/lists/linux-pm/msg27090.html
>
> This is actually a fix (for bug) in mmc/sd suspend/resume path.
> This fixed a hard-to-find MMC suspend/resume while cp in progress race 
> condition reported at below link. It was on AM335x Platform.
>
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg65425.html

Okay, thanks for testing.  I'll send the fix to Linus once it's finished
review and further testing.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

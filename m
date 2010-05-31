Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0EaL4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:56:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab0EaL4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:56:12 -0400
Date: Mon, 31 May 2010 13:56:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: Removed obsolete comment from roccat kone
 driver
In-Reply-To: <1274899850.9492.1.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005311355180.28092@pobox.suse.cz>
References: <1274899850.9492.1.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Stefan Achatz wrote:

> Removed comment that is obsolete since roccat char device is
> implemented
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index 17f2dc0..3e5b553 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -22,11 +22,6 @@
>   *      Is it possible to remove and reinstall the urb in raw-event- or any
>   *      other handler, or to defer this action to be executed somewhere else?
>   *
> - * TODO implement notification mechanism for overlong macro execution
> - *      If user wants to execute an overlong macro only the names of macroset
> - *      and macro are given. Should userland tap hidraw or is there an
> - *      additional streaming mechanism?
> - *
>   * TODO is it possible to overwrite group for sysfs attributes via udev?
>   */

Hi Stefan,

I have applied all three patches in the series. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

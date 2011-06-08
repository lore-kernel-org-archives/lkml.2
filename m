Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1FHFF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:05:28 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:60571 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1FHFF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:05:27 -0400
Message-ID: <4DEF0307.8070109@freemail.hu>
Date: Wed, 08 Jun 2011 07:05:11 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Endre Kollar <taxy443@gmail.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: change match_busid() to local function
References: <4DE3F983.5050309@freemail.hu> <20110607213112.GA11067@kroah.com> <4DEF0053.9030807@freemail.hu>
In-Reply-To: <4DEF0053.9030807@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 178.164.145.104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forget it, this change is already there in the
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git ,
on staging-next branch. I just forget to switch the branch from master
after cloning the staging-2.6 repository.

Regards,

	Márton Németh

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The function match_busid() is only referenced in the stub_main.c so it can be changed
> to static. This will remove the following warning when compiling with "make W=1 ...":
>  * drivers/staging/usbip/stub_main.c:40: warning: no previous prototype for ‘match_busid’
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
> index e9085d6..fc5b829 100644
> --- a/drivers/staging/usbip/stub_main.c
> +++ b/drivers/staging/usbip/stub_main.c
> @@ -37,7 +37,7 @@ struct kmem_cache *stub_priv_cache;
>  static struct bus_id_priv busid_table[MAX_BUSID];
>  static spinlock_t busid_table_lock;
> 
> -int match_busid(const char *busid)
> +static int match_busid(const char *busid)
>  {
>  	int i;
> 
> 


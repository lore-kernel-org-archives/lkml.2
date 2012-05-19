Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968284Ab2ESBCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:02:09 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58758 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966670Ab2ESBCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:02:07 -0400
Message-ID: <4FB6F115.70703@xenotime.net>
Date: Fri, 18 May 2012 18:02:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for May 18 (drm drivers and vgacon)
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au>
In-Reply-To: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 01:49 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 201205017:


When CONFIG_VGA_CONSOLE is not enabled:

drivers/gpu/drm/cirrus/cirrus_drv.c:87:2: error: implicit declaration of function 'vgacon_text_force'
drivers/gpu/drm/ast/ast_drv.c:224:2: error: implicit declaration of function 'vgacon_text_force'
drivers/gpu/drm/mgag200/mgag200_drv.c:96:2: error: implicit declaration of function 'vgacon_text_force'


-- 
~Randy

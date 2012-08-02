Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2HBJdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 05:33:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58567 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2HBJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 05:33:52 -0400
Message-ID: <501A4978.3010409@gmail.com>
Date: Thu, 02 Aug 2012 17:33:44 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: linux-next: removal of some trees
References: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
In-Reply-To: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:41 AM, Stephen Rothwell wrote:
> Hi Ben,
>
> Since I haven't been able to fetch these trees for quite some time and I
> haven't heard from you about them, I am removing the following trees from
> linux-next.  If/When you have time to maintain these trees again, we can
> add them back without problems.
>
> samsung	 	git://git.fluff.org/bjdooks/linux.git#next-samsung
> bjdooks-i2c	git://git.fluff.org/bjdooks/linux.git#next-i2c
>

Hi, Stephen,

By the way, please remove my kmap_atomic tree[1] as well, its mission is 
completed now. :)

Thanks!

1. git://github.com/congwang/linux


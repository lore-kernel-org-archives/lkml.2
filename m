Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1DMOFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:05:30 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:53219 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024Ab1DMOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:05:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBACmtpU1Ld/sX/2dsb2JhbAAMhEHUVJEtgSmDTXgElBOGbg
X-IronPort-AV: E=Sophos;i="4.64,204,1301889600"; 
   d="scan'208";a="106253518"
Message-ID: <4DA5ADA6.5060301@teksavvy.com>
Date: Wed, 13 Apr 2011 10:05:26 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org>
In-Reply-To: <20110413004938.GE3682@thunk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-12 08:49 PM, Ted Ts'o wrote:
>
> It's a cosemtic bug, I agree

Great.  Got a patch to fix it for me to try?

Since it currently misidentifies the filesystem type,
some of the disk management tools I have get confused.
I don't like taking any chances with user data like that.

Thanks.


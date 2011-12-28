Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1L1TY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 14:24:59 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:51639 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754064Ab1L1TYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 14:24:54 -0500
Message-ID: <4EFB7AED.1090408@xenotime.net>
Date: Wed, 28 Dec 2011 12:24:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 28 (fs-writeback)
References: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au>
In-Reply-To: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 01:18 AM, Stephen Rothwell wrote:
> Hi all,
> 
> I got bored :-(  I also hate tree wide, flag day changes :-(
> 
> Changes since 20111222:


(on both i386 and x86_64 builds:)


fs/fs-writeback.c:510:11: error: 'PAGE_CACHE_SHIFT' undeclared (first use in this function)


Needs to #include <linux/pagemap.h> ??

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1CJWIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:08:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1CJWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:08:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Thu, 10 Mar 2011 23:08:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, linux-arch@vger.kernel.org
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103102308.23006.arnd@arndb.de>
X-Provags-ID: V02:K0:CmtXspcz8hBADhTdY5vVRFJq1ZuBje7s1cF3HIUD1Hi
 8ohYfAQblI4zDZGgoofFg9vB/xWMQWfedGqy0ImIUa3knsMdWL
 vPLUTeJK3ggeCmC/ibShblzHUI92cmKJ9xZHHGlbMh0BnGimN8
 3o34Uhk14xmpH7gCzViCvtpXM2by/wumMYzx+j30oIALKUwgQk
 WFKbFL5yGwu7fzluY2uug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 March 2011 20:31:30 Sage Weil wrote:
> It is frequently useful to sync a single file system, instead of all
> mounted file systems via sync(2):
> 
>  - On machines with many mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).
>  - Some applications write lots of data to the file system and then
>    want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.
> 
> ...
> Signed-off-by: Sage Weil <sage@newdream.net>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

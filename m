Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2BBR0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:26:37 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37907 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755903Ab2BBR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:26:34 -0500
Message-ID: <4F2AD4DE.7040508@xenotime.net>
Date: Thu, 02 Feb 2012 10:24:30 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: linux-next: Tree for Feb 2 (fs/jffs2)
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
In-Reply-To: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20120201:


fs/jffs2/*.c still contains uses of ->read etc. instead of using
mtd_read() etc.

fs/jffs2/read.c:36:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/read.c:112:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/nodemgmt.c:669:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/readinode.c:83:9: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/readinode.c:676:9: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/readinode.c:954:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/readinode.c:1040:9: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/readinode.c:1216:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/readinode.c:1275:10: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/scan.c:286:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/gc.c:590:8: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/gc.c:894:10: error: 'struct mtd_info' has no member named 'read'
fs/jffs2/gc.c:977:9: error: 'struct mtd_info' has no member named 'read'

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

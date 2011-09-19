Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1ISVU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:20:58 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:33231 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932259Ab1ISVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:20:55 -0400
Message-ID: <4E77B235.30403@xenotime.net>
Date: Mon, 19 Sep 2011 14:20:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for Sept 19 (i7core_edac)
References: <20110919190117.f5d02ff24b9ab7dc17035d75@canb.auug.org.au>
In-Reply-To: <20110919190117.f5d02ff24b9ab7dc17035d75@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 02:01 AM, Stephen Rothwell wrote:
> Hi all,
> 
> The linux-next tree is now available from
> git://github.com/sfrothwell/linux-next.git as a temporary measure while
> the kernel.org servers are unavailable.
> 
> The powerpc allyesconfig build still fails today.
> 
> Changes since 20110916:

i7core_edac.c build still fails on i386:

ERROR: "__udivdi3" [drivers/edac/i7core_edac.ko] undefined!

[Untested/buggy ;] Fix was posted by Sedat Dilek here:
http://marc.info/?l=linux-next&m=131436817426589&w=2

on Aug. 26.  Just remove the last ')' in 2 places:

+			cache_line_size * 1000000);
and
+		1000000 * cache_line_size);

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

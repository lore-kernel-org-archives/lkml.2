Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0L0Vnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:43:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59935 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0L0Vnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:43:49 -0500
Message-ID: <4D19081A.3050801@oracle.com>
Date: Mon, 27 Dec 2010 13:41:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Fasheh <mfasheh@suse.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH -next] ocfs2: fix build for OCFS2_FS_STATS not enabled
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au> <20101227115508.8136331b.randy.dunlap@oracle.com> <20101227205242.GA30474@mail.oracle.com>
In-Reply-To: <20101227205242.GA30474@mail.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/10 12:52, Joel Becker wrote:
> On Mon, Dec 27, 2010 at 11:55:08AM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> When CONFIG_OCFS2_FS_STATS is not enabled:
>>
>> fs/ocfs2/cluster/tcp.c:1254: error: implicit declaration of function 'o2net_update_recv_stats'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:	Mark Fasheh <mfasheh@suse.com>
>> Cc:	Joel Becker <joel.becker@oracle.com>
>> Cc:	ocfs2-devel@oss.oracle.com
> 
> Acked-by: Joel Becker <joel.becker@oracle.com>
> 
> Do you want to push it or would you like me to?

You, please.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/

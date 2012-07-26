Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2GZPPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:15:01 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41490 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349Ab2GZPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:14:58 -0400
Message-ID: <50115EB2.8000104@xenotime.net>
Date: Thu, 26 Jul 2012 08:13:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dan Luedtke <mail@danrl.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/kernel-doc: added support for html5
References: <1343223488-1332-1-git-send-email-mail@danrl.de>	 <50103793.8000600@xenotime.net> <1343285615.12424.8.camel@localhost>
In-Reply-To: <1343285615.12424.8.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 11:53 PM, Dan Luedtke wrote:

> On Wed, 2012-07-25 at 11:14 -0700, Randy Dunlap wrote:
>> Just say "html5" or "html version 5".
>> A few years from now it won't be modern.
> Haven't thought of that. Will be changed, thanks!
> 
>> Have you tested typedef, enum, DOC:, etc.?
> Yes, here are a few examples:
> 
> DOC:
> https://www.nonattached.net/lanyfs/doc-linux.php#doc:LanyFS_Inode_Cache
> 
> Typedef:
> https://www.nonattached.net/lanyfs/doc-linux.php#typedef:lanyfs_blk_t
> (You were right, it wasn't there yesterday, sorry!)
> 
> Enum:
> https://www.nonattached.net/lanyfs/doc-fsutils.php#enum:mklanyfs_time
> (It is a userspace tool, but it uses kernel-doc format)
> 
> I'll send the patches out in a minute.
> 
> Thanks!


and thanks for the tested examples.

-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2AQJYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:24:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2AQJYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:24:51 -0500
Message-ID: <4F153EFA.4070404@cn.fujitsu.com>
Date: Tue, 17 Jan 2012 17:27:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120116135442.GA28487@shiny> <4F1534FD.30707@cn.fujitsu.com> <20120117084650.GP11715@one.firstfloor.org>
In-Reply-To: <20120117084650.GP11715@one.firstfloor.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-17 17:23:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-17 17:23:44,
	Serialize complete at 2012-01-17 17:23:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> It's because decompressing inline extents always fails. I've fixed it
>> and will send the patch out in a new mail thread.
> 
> Thanks for fixing.
> 
>>
>> But seems there's bug in lib snappy code, which makes the decompressed
>> data doesn't quite match the original data.
>>
>> Simply copy a file to a btrfs filesystem with snappy enabled, and clear
>> page cache, and check the file:
> 
> Hmm weird, I have never seen this. Do you have a reproducer?
> 
> The basic compression code is quite well tested, I have a reasonable
> unit test.
> 

At first I saved emails and patched them in linux-btrfs git tree, and I
got weired result. Then I pulled the snappy branch directly, and now
nothing is wrong.. Sorry for the noise.

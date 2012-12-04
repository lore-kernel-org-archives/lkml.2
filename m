Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2LDNkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:40:25 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:57545 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751689Ab2LDNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:40:23 -0500
Message-ID: <50BDFD40.1020202@tao.ma>
Date: Tue, 04 Dec 2012 21:40:16 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>,
        boyu.mt@taobao.com, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: next: ext4 build failure
References: <50BDC25C.5020509@suse.cz> <20121204132701.GA29083@thunk.org>
In-Reply-To: <20121204132701.GA29083@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 124.65.207.217 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,
On 12/04/2012 09:27 PM, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 10:29:00AM +0100, Jiri Slaby wrote:
>> Hi,
>>
>> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
>> Author: Tao Ma <boyu.mt@taobao.com>
>> Date:   Sun Dec 2 20:30:52 2012 -0500
>>
>>     ext4: let fallocate handle inline data correctly
>>
>> added
>>
>> static int int ext4_convert_inline_data(struct inode *inode)
>>
>>        ^^^^^^^
>>
>> when EXT4_FS_XATTR is unset.
>>
>> Care to fix that?
> 
> Oops.  Thanks for catching this!!!
Please push the patch with the subject "[PATCH] ext4: Fix inline data
build warning found by kernel build testing." and these error should go
away. And also Dan's smatch has found another issue and I have sent out
the patch with subject "[PATCH] ext4: Fix inline data build warning
found by kernel build testing.".

Thanks
Tao
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


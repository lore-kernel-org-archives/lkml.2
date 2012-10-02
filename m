Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2JBJbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:31:43 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:46651 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab2JBJbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:31:41 -0400
Message-ID: <506AB426.4000407@ahsoftware.de>
Date: Tue, 02 Oct 2012 11:30:14 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz> <506474E8.3030300@ahsoftware.de> <20120927200342.GB12553@quack.suse.cz> <506746EF.5070000@ahsoftware.de> <20121001091001.GA22800@quack.suse.cz> <506960AE.2000402@ahsoftware.de>
In-Reply-To: <506960AE.2000402@ahsoftware.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.10.2012 11:21, schrieb Alexander Holler:
> Hello,
>
> Am 01.10.2012 11:10, schrieb Jan Kara:
>
>>> sha1sum Tainted: P           O 3.5.4-00009-gfa43f23-dirty #228
>>    BTW, fglrx moodule taints the kernel because it is a proprietary
>> driver.
>
> I know.
>
>> Can you reproduce the issue without this module loaded?
>
> I will try it with a clean 3.6. Most of the 9 additional patches here
> are for ARM boxes, but anyway. I will need a few days.

Just tried my "tar cp . | mbuffer | bzip2smp >/usb3/ext4/foo.tar.bz2 
using a kernel 3.6 without using fglrx and without any additional 
patches. The first try already ended up in a broken archive (tar djf => 
bzip2: Data integrity error when decompressing), but (again) without the 
BUG() in fs/buffer.c getting hit. Will do some more tests, trying hit 
that BUG().

Regards,

Alexander


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2LDQMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:12:54 -0500
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:35716 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754246Ab2LDQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:12:50 -0500
Message-ID: <50BDF6B2.2030302@tao.ma>
Date: Tue, 04 Dec 2012 21:12:18 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: boyu.mt@taobao.com, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next: ext4 build failure
References: <50BDC25C.5020509@suse.cz>
In-Reply-To: <50BDC25C.5020509@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 124.65.207.217 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Thanks for the report.

The corresponding fix is already sent to Ted in the patch named "ext4:
Fix inline data build warning found by kernel build testing.", but it
seems that Ted hasn't pushed it into ext4dev yet.

Thanks
Tao

On 12/04/2012 05:29 PM, Jiri Slaby wrote:
> Hi,
> 
> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
> Author: Tao Ma <boyu.mt@taobao.com>
> Date:   Sun Dec 2 20:30:52 2012 -0500
> 
>     ext4: let fallocate handle inline data correctly
> 
> added
> 
> static int int ext4_convert_inline_data(struct inode *inode)
> 
>        ^^^^^^^
> 
> when EXT4_FS_XATTR is unset.
> 
> Care to fix that?
> 
> thanks,
> 


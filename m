Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0ERGGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:06:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49949 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab0ERGGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:06:42 -0400
Message-ID: <4BF22EF0.8010202@cn.fujitsu.com>
Date: Tue, 18 May 2010 14:08:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Liu <lingjiujianke@gmail.com>
CC: mike.miller@hp.com, linux-kernel@vger.kernel.org, iss_storagedev@hp.com,
       liuqi@thunderst.com
Subject: Re: [PATCH] cciss: fix code style in drivers/block/cciss_scsi.c
References: <AANLkTilN3PuzIweiocSMOsYkYtcOHeQbh_KrOkLiAigk@mail.gmail.com>
In-Reply-To: <AANLkTilN3PuzIweiocSMOsYkYtcOHeQbh_KrOkLiAigk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Liu wrote:
> Hi, Mike Miller,
> 
> if kmalloc memory for ld_buff failed,it will free currentsd  and
> ld_buff once more

No, it won't.

> so i think this patch may be better
> 
> fix code style in drivers/block/cciss_scsi.c
> 

There is no bug or coding style issue, so just leave the code as it is.



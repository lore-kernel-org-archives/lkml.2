Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937398Ab0CPBmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:42:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57776 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S937385Ab0CPBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:41:57 -0400
Message-ID: <4B9EE223.7020302@cn.fujitsu.com>
Date: Tue, 16 Mar 2010 09:42:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: Re: [PATCH] block: make CONFIG_BLK_CGROUP visible
References: <4B9DA6F5.3070606@cn.fujitsu.com> <20100315115724.GK5768@kernel.dk>
In-Reply-To: <20100315115724.GK5768@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Mar 15 2010, Li Zefan wrote:
>> Make the config visible, so we can choose from CONFIG_BLK_CGROUP=y
>> and CONFIG_BLK_CGROUP=m when CONFIG_IOSCHED_CFQ=m.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> What kernel is this against?
> 

It's against linus' tree. I've just checked the block tree, and found
it needs to be synced, otherwise this patch can't be applied on it.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0CQCCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:02:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0CQCCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:02:08 -0400
Message-ID: <4BA03859.4060300@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 10:03:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
References: <20100317125200.5deb72ba.sfr@canb.auug.org.au>
In-Reply-To: <20100317125200.5deb72ba.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> block/Kconfig between commit 67523c48aa74d5637848edeccf285af1c60bf14a
> ("cgroups: blkio subsystem as module") from Linus' tree and commit
> 910ac735bad53ce54741a72a5b19ab69794ae069 ("block: make CONFIG_BLK_CGROUP
> visible") from the block tree.
> 
> I used the block tree version.

The merge is correct, thanks!


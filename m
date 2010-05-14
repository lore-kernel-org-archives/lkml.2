Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0ENGz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:55:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0ENGzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:55:54 -0400
Message-ID: <4BECF467.1060600@cn.fujitsu.com>
Date: Fri, 14 May 2010 14:57:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] kconfig: print symbol type in help text
References: <4BE3AB91.80606@cn.fujitsu.com>
In-Reply-To: <4BE3AB91.80606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, what do you think about those patches? Seems
Randy has had no further comments on them.

Li Zefan wrote:
> Randy suggested to print out the symbol type in gconfig.
> 
> Note this change does more than Randy's suggestion, that it also
> affects menuconfig and "make config".
> 
>   │ Symbol: BLOCK [=y]
>   │ Type  : boolean
>   │ Prompt: Enable the block layer
>   │   Defined at block/Kconfig:4
>   │   Depends on: EMBEDDED [=n]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

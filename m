Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0DOHmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:42:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61196 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab0DOHmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:42:06 -0400
Message-ID: <4BC6C3A8.3020409@cn.fujitsu.com>
Date: Thu, 15 Apr 2010 15:43:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 6/6] gconfig: add support to show hidden options that
 have prompts
References: <4BC539DD.5040003@cn.fujitsu.com>	<4BC53A90.9020304@cn.fujitsu.com> <20100414164847.661fe9d6.randy.dunlap@oracle.com>
In-Reply-To: <20100414164847.661fe9d6.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 14 Apr 2010 11:46:24 +0800 Li Zefan wrote:
> 
>> There's a button in gconfig to "Show all options", but I think
>> normally we are not interested in those configs which have no
>> prompt and thus can't be changed, so here I add a new button to
>> show hidden options which have prompts.
> 
> (The new option is called "Show all prompt options".)
> 
> These patches are looking good so far in my limited testing.
> 
> However, if gconfig is going to live, it needs at least one more thing:
> it should display the kconfig symbol type (tristate, boolean, etc.)
> like xconfig does (explicitly) and menuconfig does (by using [x] or <x>
> in the menu).
> 

Hmm, I think I can spend some time on this.

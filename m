Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0DNXtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:49:17 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:20961 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0DNXtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:49:15 -0400
Date: Wed, 14 Apr 2010 16:48:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 6/6] gconfig: add support to show hidden options that
 have prompts
Message-Id: <20100414164847.661fe9d6.randy.dunlap@oracle.com>
In-Reply-To: <4BC53A90.9020304@cn.fujitsu.com>
References: <4BC539DD.5040003@cn.fujitsu.com>
	<4BC53A90.9020304@cn.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4BC6546A.0049:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 11:46:24 +0800 Li Zefan wrote:

> There's a button in gconfig to "Show all options", but I think
> normally we are not interested in those configs which have no
> prompt and thus can't be changed, so here I add a new button to
> show hidden options which have prompts.

(The new option is called "Show all prompt options".)

These patches are looking good so far in my limited testing.

However, if gconfig is going to live, it needs at least one more thing:
it should display the kconfig symbol type (tristate, boolean, etc.)
like xconfig does (explicitly) and menuconfig does (by using [x] or <x>
in the menu).

thanks,
---
~Randy

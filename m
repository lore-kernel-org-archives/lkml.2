Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894Ab2HHVKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:10:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2HHVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:10:27 -0400
Date: Wed, 8 Aug 2012 14:10:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] proc: add /proc/pid/shmaps
In-Reply-To: <1344431059-12514-1-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.00.1208081409300.7178@chino.kir.corp.google.com>
References: <1344431059-12514-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Qiaowei Ren wrote:

> Add a shmaps entry to /proc/pid: show information about shared memory in an address space.
> 
> People that use shared memory and want to perform an analyzing about it. For example, judge whether any memory address is shared. This file just contains 'share' part of /proc/pid/maps now. There are too many contents in maps, and so we have to do a lot of analysis to obtain relative information every time.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>

Nack as unnecessary; /proc/pid/maps already explicitly emits 's' for 
VM_MAYSHARE and 'p' otherwise so this information is already available to 
userspace.

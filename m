Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2F0GKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:10:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2F0GKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:10:34 -0400
Date: Tue, 26 Jun 2012 23:10:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: [RFC PATCH 1/12] memory-hotplug : rename remove_memory to
 offline_memory
In-Reply-To: <4FEA9D5C.1080508@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206262309301.32567@chino.kir.corp.google.com>
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9D5C.1080508@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012, Yasuaki Ishimatsu wrote:

> remove_memory() does not remove memory but just offlines memory. The patch
> changes name of it to offline_memory().
> 

The kernel is never going to physically remove the memory itself, so I 
don't see the big problem with calling it remove_memory().  If you're 
going to change it to offline_memory(), which is just as good but not 
better, then I'd suggest changing add_memory() to online_memory() for 
completeness.

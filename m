Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2JMJ4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:56:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43928 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2JMJ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:56:02 -0400
Date: Sat, 13 Oct 2012 02:56:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm: cleanup register_node()
In-Reply-To: <5077D353.3010708@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210130255470.7462@chino.kir.corp.google.com>
References: <5077D353.3010708@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Yasuaki Ishimatsu wrote:

> register_node() is defined as extern in include/linux/node.h. But the function
> is only called from register_one_node() in driver/base/node.c.
> 
> So the patch defines register_node() as static.
> 
> CC: David Rientjes <rientjes@google.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks!

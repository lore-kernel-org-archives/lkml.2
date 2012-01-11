Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081Ab2AKVv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:51:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54931 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab2AKVv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:51:57 -0500
Date: Wed, 11 Jan 2012 13:51:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hillf Danton <dhillf@gmail.com>
cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: deactivate isolated pages with lru lock
 released
In-Reply-To: <CAJd=RBAiAfyXBcn+9WO6AERthyx+C=cNP-romp9YJO3Hn7-U-g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201111351420.21755@chino.kir.corp.google.com>
References: <CAJd=RBAiAfyXBcn+9WO6AERthyx+C=cNP-romp9YJO3Hn7-U-g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Hillf Danton wrote:

> Spinners on other CPUs, if any, could take the lru lock and do their jobs while
> isolated pages are deactivated on the current CPU if the lock is released
> actively. And no risk of race raised as pages are already queued on locally
> private list.
> 
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

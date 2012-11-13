Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2KMVHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:07:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65186 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2KMVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:07:33 -0500
Date: Tue, 13 Nov 2012 13:07:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com, dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 1/1] mm: Export a function to get vm committed memory
In-Reply-To: <1352818957-9229-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.DEB.2.00.1211131307090.5164@chino.kir.corp.google.com>
References: <1352818957-9229-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, K. Y. Srinivasan wrote:

> It will be useful to be able to access global memory commitment from device
> drivers. On the Hyper-V platform, the host has a policy engine to balance
> the available physical memory amongst all competing virtual machines
> hosted on a given node. This policy engine is driven by a number of metrics
> including the memory commitment reported by the guests. The balloon driver
> for Linux on Hyper-V will use this function to retrieve guest memory commitment.
> This function is also used in Xen self ballooning code.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Acked-by: David Rientjes <rientjes@google.com>

Very nice!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533Ab2DKXym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:54:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39355 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761510Ab2DKXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:54:39 -0400
Date: Wed, 11 Apr 2012 16:54:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Ying Han <yinghan@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Removal of lumpy reclaim V2
In-Reply-To: <1334162298-18942-1-git-send-email-mgorman@suse.de>
Message-ID: <alpine.LSU.2.00.1204111651290.26528@eggly.anvils>
References: <1334162298-18942-1-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Mel Gorman wrote:
> 
> Removing lumpy reclaim saves almost 900K of text where as the full series
> removes 1200K of text.

Impressive...

> 
>    text	   data	    bss	    dec	    hex	filename
> 6740375	1927944	2260992	10929311	 a6c49f	vmlinux-3.4.0-rc2-vanilla
> 6739479	1927944	2260992	10928415	 a6c11f	vmlinux-3.4.0-rc2-lumpyremove-v2
> 6739159	1927944	2260992	10928095	 a6bfdf	vmlinux-3.4.0-rc2-nosync-v2

... but I fear you meant " bytes" instead of "K" ;)

Hugh

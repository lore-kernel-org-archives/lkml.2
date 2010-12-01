Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0LARAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:00:22 -0500
Received: from coloquinte.cristau.org ([91.121.16.100]:58091 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0LARAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:00:21 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 12:00:21 EST
Date: Wed, 1 Dec 2010 17:54:18 +0100
From: Julien Cristau <jcristau@debian.org>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] drm: fix headers to include linux/types.h
Message-ID: <20101201165418.GU5063@radis.liafa.jussieu.fr>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
 <1291216245-18574-2-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291216245-18574-2-git-send-email-virtuoso@slind.org>
X-Operating-System: Linux 2.6.32-5-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec  1, 2010 at 17:10:42 +0200, Alexander Shishkin wrote:

> For headers that get exported to userland and make use of u32 style
> type names, it is advised to include linux/types.h.
> 
> This fixes 5 headers_check warnings.
> 
How many times does this need to be NAKed?  These headers are shared
with the BSDs, and they include drm.h which has the linux/types.h
include on linux already.

Cheers,
Julien

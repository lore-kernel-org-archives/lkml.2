Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0LATjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:39:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717Ab0LATjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:39:15 -0500
Date: Wed, 1 Dec 2010 11:38:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Julien Cristau <jcristau@debian.org>
Cc: Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/4] drm: fix headers to include linux/types.h
Message-Id: <20101201113841.46e92def.akpm@linux-foundation.org>
In-Reply-To: <20101201165418.GU5063@radis.liafa.jussieu.fr>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
	<1291216245-18574-2-git-send-email-virtuoso@slind.org>
	<20101201165418.GU5063@radis.liafa.jussieu.fr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 17:54:18 +0100
Julien Cristau <jcristau@debian.org> wrote:

> On Wed, Dec  1, 2010 at 17:10:42 +0200, Alexander Shishkin wrote:
> 
> > For headers that get exported to userland and make use of u32 style
> > type names, it is advised to include linux/types.h.
> > 
> > This fixes 5 headers_check warnings.
> > 
> How many times does this need to be NAKed?

Until someone gets a clue and puts comments in there explaining this?

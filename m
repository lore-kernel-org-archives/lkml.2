Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2FKLMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:12:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51016 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2FKLMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:12:48 -0400
Subject: Re: [PATCH] Add seq_vprintf and use in gfs2 (was Re: GFS2: Cache
 last hash bucket for glock seq_files)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1339410072.2734.17.camel@menhir>
References: <1339152726.2752.3.camel@menhir>
	 <1339230731.6001.159.camel@edumazet-glaptop>
	 <1339403377.2734.7.camel@menhir>
	 <1339404517.6001.1767.camel@edumazet-glaptop>
	 <1339410072.2734.17.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 13:12:44 +0200
Message-ID: <1339413164.6001.2046.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 11:21 +0100, Steven Whitehouse wrote:

> Thats true, but are there any arches with a 64k page size? In any case
> I'll follow up with another patch for that rather than try to combine it
> with this one...

Some arches have page size from 16K to 1MB in size

sh, frv, hexagon, tile, ia64, mips, microblaze, sparc64, ppc64...




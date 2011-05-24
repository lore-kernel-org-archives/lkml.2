Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1EXLzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:55:25 -0400
Received: from tundra.namei.org ([65.99.196.166]:42613 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1EXLzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:55:24 -0400
Date: Tue, 24 May 2011 21:52:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: SLUB regression in current Linus
Message-ID: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started experiencing a boot hang in 2.6.39+, and bisected it to this 
change:

commit 442b06bcea23a01934d3da7ec5898fa154a6cafb
Author: Christoph Lameter <cl@linux.com>
Date:   Tue May 17 16:29:31 2011 -0500

    slub: Remove node check in slab_free


Reverting the patch appears to fix the hang for me, although I'm not sure 
what the actual problem is.

This is on a quad-core Opteron (1352). Let me know if you need any further 
info.



- James
-- 
James Morris
<jmorris@namei.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1EXMHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:07:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:59518 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1EXMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:07:15 -0400
Date: Tue, 24 May 2011 22:04:46 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, James Morris wrote:

> Reverting the patch appears to fix the hang for me, although I'm not sure 
> what the actual problem is.

Disabling slub debugging also fixes it.


- James
-- 
James Morris
<jmorris@namei.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1KGHbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 02:31:33 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45631
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab1KGHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 02:31:32 -0500
Date: Mon, 7 Nov 2011 02:31:27 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Hugh Dickins <hughd@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111107073127.GA7410@infradead.org>
References: <1320614101.3226.5.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320614101.3226.5.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 06, 2011 at 06:15:01PM -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> This patch adds a new RLIMIT_TMPFSQUOTA resource limit to restrict an individual user's quota across all mounted tmpfs filesystems.
> It's well known that a user can easily fill up commonly used directories (like /tmp, /dev/shm) causing programs to break through DoS.

Please jyst implement the normal user/group quota interfaces we use for other
filesystem.  


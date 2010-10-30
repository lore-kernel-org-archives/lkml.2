Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0J3JGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:06:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54158 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0J3JGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:06:47 -0400
Date: Sat, 30 Oct 2010 10:06:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Helge Deller <deller@gmx.de>, David Howells <dhowells@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: shm: fix information leak to userland
Message-ID: <20101030090644.GX19804@ZenIV.linux.org.uk>
References: <1288429477-21920-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288429477-21920-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 01:04:37PM +0400, Vasiliy Kulikov wrote:
> Structure shmid_ds is copied to userland with shm_unused{,2,3}
> fields unitialized.  It leads to leaking of contents of kernel stack memory.
 
ACK; send to Linus and add Cc: stable@kernel.org

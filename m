Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1FHWdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:33:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab1FHWdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:33:02 -0400
Date: Wed, 8 Jun 2011 15:32:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-Id: <20110608153208.dc705cda.akpm@linux-foundation.org>
In-Reply-To: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jun 2011 14:46:13 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> I'd like to ask for overlayfs to be merged into 3.1.

Dumb questions:

I've never really understood the need for fs overlaying.  Who wants it?
What are the use-cases?

This sort of thing could be implemented in userspace and wired up via
fuse, I assume.  Has that been attempted and why is it inadequate?

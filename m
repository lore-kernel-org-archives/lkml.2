Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2LFWuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:50:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2LFWuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:50:22 -0500
Date: Thu, 6 Dec 2012 14:50:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kexec@lists.infradead.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/8] remove vm_struct list management
Message-Id: <20121206145020.93fd7128.akpm@linux-foundation.org>
In-Reply-To: <1354810175-4338-1-git-send-email-js1304@gmail.com>
References: <1354810175-4338-1-git-send-email-js1304@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Dec 2012 01:09:27 +0900
Joonsoo Kim <js1304@gmail.com> wrote:

> I'm not sure that "7/8: makes vmlist only for kexec" is fine.
> Because it is related to userspace program.
> As far as I know, makedumpfile use kexec's output information and it only
> need first address of vmalloc layer. So my implementation reflect this
> fact, but I'm not sure. And now, I don't fully test this patchset.
> Basic operation work well, but I don't test kexec. So I send this
> patchset with 'RFC'.

Yes, this is irritating.  Perhaps Vivek or one of the other kexec
people could take a look at this please - if would obviously be much
better if we can avoid merging [patch 7/8] at all.

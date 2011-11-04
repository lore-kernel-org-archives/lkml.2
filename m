Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1KDKJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:09:32 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52005 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1KDKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <20111103075211.GD6993@infradead.org>
References: <patchbomb.1320306168@localhost6.localdomain6>
	<c0db93dbb414ab6dbcde.1320306171@localhost6.localdomain6>
	<20111103075211.GD6993@infradead.org>
Date: Fri, 4 Nov 2011 10:09:29 +0000
Message-ID: <CAJSP0QV0w8kKgQ57CEFyPdJT-==aS5xnNY7bkLnqd51d0eJdLQ@mail.gmail.com>
Subject: Re: [PATCH 3 of 5] virtio: support unlocked queue kick
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: MichaelS.Tsirkist@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 7:52 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Nov 03, 2011 at 06:12:51PM +1030, Rusty Russell wrote:
>> Based on patch by Christoph for virtio_blk speedup:
>
> Please credit it to Stefan - he also sent a pointer to his original
> version in reply to the previous thread.

Thank you Christoph.  Here the pointer to the original mailing list thread:

"Here is the patch:
https://github.com/stefanha/linux/commit/a6d06644e3a58e57a774e77d7dc34c4a5a2e7496

Or as an email if you want to track it down in your inbox:
http://www.spinics.net/lists/linux-virtualization/msg14616.html"

Stefan

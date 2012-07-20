Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2GTKbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:31:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51809 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GTKb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120719130957.GD9303@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
	<1342169711-12386-6-git-send-email-asias@redhat.com>
	<87mx2vrjdl.fsf@codemonkey.ws>
	<20120719130957.GD9303@redhat.com>
Date: Fri, 20 Jul 2012 11:31:26 +0100
Message-ID: <CAJSP0QWWKdLCMw1_A=W85iUTFgOu15gEpEOs7hg7ULjxcbMLRA@mail.gmail.com>
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Khoa Huynh <khoa@us.ibm.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 2:09 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Thu, Jul 19, 2012 at 08:05:42AM -0500, Anthony Liguori wrote:
>> Of course, the million dollar question is why would using AIO in the
>> kernel be faster than using AIO in userspace?
>
> Actually for me a more important question is how does it compare
> with virtio-blk dataplane?

Hi Khoa,
I think you have results of data-plane and vhost-blk?  Is the
vhost-blk version identical to Asias' recent patches?

Stefan

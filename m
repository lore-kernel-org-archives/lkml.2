Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0JKPqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:46:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43372 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab0JKPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PZeU2fKBgh+WtWme7qGb1W8RHP8/I2Ot8uIpIvmOShwK7ORABwKwFfWYhP1GVTScF7
         J9yXx15p6u6elxsBIiOZcgtQlMoh+hfgf5x3xNA+J0LdRIVUyKFPp7THGoxSeC4aylat
         Br4bxV+Gesl3NxLVpwxZNq5gZYrCvqoaIGkHE=
Subject: Re: Horrible btrfs performance on cold cache
From: Calvin Walton <calvin.walton@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 11:46:19 -0400
Message-ID: <1286811979.9645.5.camel@ayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
> Hi,
> 
> I use btrfs on most of my volumes on my laptop, and I've always felt
> booting was very slow, but definitely sure is slow, is starting up
> Google Chrome:
> 
> encrypted ext4: ~20s
> btrfs: ~2:11s
> 
> I have tried different things to find out exactly what is the issue,
> but haven't quite found it yet.

If you've been using this volume for a while, it could just have become
badly fragmented. You could try btrfs's fancy online defragmentation
abilities to see if that'll give you an improvement:

# btrfs filesystem defragment /mountpoint/of/volume

Let us know if that helps, of course :)

-- 
Calvin Walton <calvin.walton@gmail.com>


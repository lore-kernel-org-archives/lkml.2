Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab0FOMBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:01:30 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49925 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0FOMB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:01:28 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>,
       linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
References: <201006092035.46481.knikanth@novell.com>
	<87aaqzp39a.fsf@devron.myhome.or.jp>
	<201006151611.36443.knikanth@novell.com>
Date: Tue, 15 Jun 2010 21:01:19 +0900
In-Reply-To: <201006151611.36443.knikanth@novell.com> (Nikanth Karthikesan's
	message of "Tue, 15 Jun 2010 16:11:35 +0530")
Message-ID: <87typ4h5dc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan <knikanth@novell.com> writes:

>> I have no objections to such those operations (likewise make hole,
>> truncate any range, etc. etc.).
>
> As far as FAT is concerned, Sparse files would break the on-disk format?

Yes. In the case of making hole on FAT, I guess it will return the
error, or emulate it by zero fill.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

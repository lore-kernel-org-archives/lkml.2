Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2HHDgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:36:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2HHDg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:36:27 -0400
Date: Tue, 7 Aug 2012 20:36:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wesley Miaw <wmiaw@netflix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will =?utf-8?B?RHJld3J54oSi?= <w@google.com>,
        "msb@google.com" <msb@google.com>
Subject: Re: [PATCH] dm: verity support data device offset
Message-ID: <20120808033621.GA12743@kroah.com>
References: <66ADE819-D9DE-4A95-9B48-9C4B060CFB06@netflix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66ADE819-D9DE-4A95-9B48-9C4B060CFB06@netflix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 12:43:28AM +0000, Wesley Miaw wrote:
> I needed to add support for dm-verity with data that is offset into a block device. As part of this I found that the existing code did not compute the correct hash block index if the data_start might be non-zero. Here's a patch to add support for a data offset target parameter as well as a fix to the hash block index computation.
> 
> Patch and (hopefully proper) commit message below. Thanks.
> --
> Wesley Miaw
> 
> ============================================================
> 
> Add data device start block index to dm-verity target parameters to support verity targets where the data does not begin at sector 0 of the block device. Also fix the hash block index computation so it takes into account data offsets.

You forgot a "Signed-off-by:" line in the patch description here.  Take
a look at the kernel file, Documentation/SubmittingPatches for what this
means, and how to properly format the patch so it can be applied.

Also try to send the patch to the correct people who can review, and
(hopefully) apply it.  The tool, scripts/get_maintainer.pl can help you
out with that (hint, you didn't send it to anyone who could do anything
about it.)

Hope this helps,

greg k-h

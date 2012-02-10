Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2BJUwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:52:22 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41868 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab2BJUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:52:21 -0500
Message-ID: <4F358380.2050708@redhat.com>
Date: Fri, 10 Feb 2012 21:52:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Nelson, Doug" <doug.nelson@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
References: <Pine.LNX.4.44L0.1202101533210.1281-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202101533210.1281-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 09:43 PM, Alan Stern wrote:
> By the way, I see the same sort of thing happening with mdadm.  Maybe I
> haven't gotten things configured quite right...

These are just probing ioctls, that would have failed the same way with 
or without the patch.

Paolo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab0EGRtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:49:06 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:44465 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0EGRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:49:03 -0400
Message-ID: <4BE4528C.5000305@sandeen.net>
Date: Fri, 07 May 2010 12:49:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Bernd Eckenfels <bernd-10@eckenfels.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: ext4 is faster with LVM than without, and other filesystem benchmarks
References: <201005071528.o47FSVas054141@neskaya.eckenfels.net>
In-Reply-To: <201005071528.o47FSVas054141@neskaya.eckenfels.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> In article <20100507142310.GF13143@lh.kyla.fi> you wrote:
>> I think the most surprising result of the benchmarks is that ext4
>> seems to be significantly faster under LVM than on the raw /dev/sdd1
>> partition. Without LVM the variance in run times is much larger.
> 
> Sounds like the syncs/barriers never reach the disk with LVM. What mount
> journal/sync options did you use?  default?  Is dmesg telling you that
> barriers have been turned off for the lvm case?  IF yo uwant it fast and
> dirty try nobarrier,data=writeback :)

LVM barriers should be working in that kernel, though... still, comparing
mount -o nobarrier on each might yield a clue there.

-Eric


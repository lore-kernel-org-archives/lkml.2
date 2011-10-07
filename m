Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab1JGOyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:54:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:55600 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1JGOyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:54:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: A =?UTF-8?B?UGx1bWJlcuKAmXMgV2lzaCBMaXN0IGZvciBMaW51eA==?=
Date: Fri, 07 Oct 2011 20:57:35 +0600
Message-ID: <4E8F135F.2060301@gmail.com>
References: <CAE2SPAZci=u__d58phePCftVr_e+i+N2YU-JYjGDG_b3TmYTSQ@mail.gmail.com> <20111007144027.3c785c76@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, david@fubar.dk, greg@kroah.com,
        lennart@poettering.net, harald@redhat.com
X-Gmane-NNTP-Posting-Host: 31.162.103.209
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110925 Lightning/1.0b3pre Thunderbird/3.1.12
In-Reply-To: <20111007144027.3c785c76@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.10.2011 19:40, Alan Cox пишет:
> On Fri, 7 Oct 2011 15:09:16 +0200
> Bastien ROUCARIES<roucaries.bastien@gmail.com>  wrote:
>
>> For fat a special xattr for root inode ?
>
> If it's as Kay says a specific magic part of the directory and we need
> this just as a fixup for FAT and NTFS then probably an ioctl on it will
> do the job nicely. Sometimes stretching existing API's in semi-sane ways
> actually gets to produce worse special cases (like tar restoring the
> volume label by accident depending upon its settings)

I'd say that we also need to consider EXFAT which is available only for 
FUSE, and the fact that the FUSE-based NTFS driver has more features 
than the kernel driver. And, frankly speaking, I don't think that FAT 
belongs to the kernel at all. So any proposed solution has to be 
extensible enough to also cover FUSE.

-- 
Alexander E. Patrakov


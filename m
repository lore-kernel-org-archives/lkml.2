Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0G0Xek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:34:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab0G0Xej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:34:39 -0400
Message-ID: <4C4F6DF2.6090905@ontolinux.com>
Date: Wed, 28 Jul 2010 01:38:26 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: bchociej@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:v6WMW1UQTNHEIEub1H0Y9MXweSLQyHxm2UauE2J0aOx
 47Lmbb1B75Ybur3u9pVsTIVZFWe6a15wEDyC2dKzplPPU0582+
 wcbyQP08VgPuy2q65pb/O+waOwVXoRzEjaLwJBM/QTyY22cqk3
 lbVxy675vciT0MXOHl8Mk5PXTmZ0xH0KXOyBbbc5CaTY0I0Jbp
 ceAmj1GpnFGLHp74W/PuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the 28.07.2010 00:00, Ben Chociej wrote:
> INTRODUCTION:
>
> This patch series adds experimental support for tracking data
> temperature in Btrfs. Essentially, this means maintaining some key
> stats (like number of reads/writes, last read/write time, frequency of
> reads/writes), then distilling those numbers down to a single
> "temperature" value that reflects what data is "hot."
>
> The long-term goal of these patches, as discussed in the Motivation
> section at the end of this message, is to enable Btrfs to perform
> automagic relocation of hot data to fast media like SSD. This goal has
> been motivated by the Project Ideas page on the Btrfs wiki.
>
> Of course, users are warned not to run this code outside of development
> environments. These patches are EXPERIMENTAL, and as such they might
> eat your data and/or memory.
>
>
> MOTIVATION:
>
> The overall goal of enabling hot data relocation to SSD has been
> motivated by the Project Ideas page on the Btrfs wiki at
> https://btrfs.wiki.kernel.org/index.php/Project_ideas. It is hoped that
> this initial patchset will eventually mature into a usable hybrid
> storage feature set for Btrfs.
>
> This is essentially the traditional cache argument: SSD is fast and
> expensive; HDD is cheap but slow. ZFS, for example, can already take
> advantage of SSD caching. Btrfs should also be able to take advantage
> of hybrid storage without any broad, sweeping changes to existing code.
>    

Wouldn't this feature be useful for other file systems as well, so that 
a more general and not an only Btrfs related solution is preferable?

> With Btrfs's COW approach, an external cache (where data is *moved* to
> SSD, rather than just cached there) makes a lot of sense. Though these
> patches don't enable any relocation yet, they do lay an essential
> foundation for enabling that functionality in the near future. We plan
> to roll out an additional patchset introducing some of the automatic
> migration functionality in the next few weeks.
>
>    

  With all the best
Christian Stroetmann

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0HZLyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:54:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20150 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0HZLyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:54:52 -0400
Date: Thu, 26 Aug 2010 07:53:36 -0400
From: Chris Mason <chris.mason@oracle.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.35.3] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Message-ID: <20100826115336.GW14190@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	"Carlos R. Mafra" <crmafra2@gmail.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100826095357.GA7202@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826095357.GA7202@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 11:53:57AM +0200, Carlos R. Mafra wrote:
> Hi,
> 
> I've just got this BUG: message in dmesg which I think is btrfs related.
> 
> I have a btrfs filesystem in a memory card which I use to contain the 
> cache and config of chromium (to avoid writing to much in the SSD):
> 
> /dev/mmcblk0p1 on /home/mafra/mmc type btrfs (rw,noexec,nosuid,nodev,noatime,noacl,compress)
> 
> and the last message before the bug is about the memory card.

Hmmm it is definitely btrfs related.  Do you continue to get it after
rebooting?

-chris

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2FTRYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:24:13 -0400
Received: from smtp205.alice.it ([82.57.200.101]:43510 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab2FTRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:24:09 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 13:24:09 EDT
Message-ID: <4FE205CF.9020509@libero.it>
Date: Wed, 20 Jun 2012 19:18:07 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org, dave@jikos.cz, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, chris.mason@fusionio.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On 06/20/2012 12:35 PM, Alexander Block wrote:
> The patch also does proper vfs mount checks, so cross mount 
> point reflinks are not possible with this patch. It only allows cross 
> reflinks between two subvolumes which are in the same mount point.

Thanks for working on that. What happens if two subvolumes of the same
filesystem are mounted on two different places ?

I usually do:
 mount -o subvol=__active /dev/sdX /
 mount -o subvol=.        /dev/sdX /var/btrfs

So two different subvolumes of the same filesystem (the one on /dev/sdX)
are mounted on two different places.

Is it possible to do
 cp --reflink /tmp/foo /var/btrfs/tmp/foo2

Thanks
G.Baroncelli


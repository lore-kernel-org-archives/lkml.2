Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab0EZBVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:21:16 -0400
Received: from bosmailout11.eigbox.net ([66.96.190.11]:41131 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab0EZBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:21:08 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 21:21:08 EDT
X-EN-OrigOutIP: 10.20.18.1
X-EN-IMPSID: N0pt1e00201P9Sa010ptm3
Message-ID: <4BFC700C.3050008@jaysonking.com>
Date: Tue, 25 May 2010 19:49:16 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Jayson R. King" <dev@jaysonking.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [10/24] vfs: Add no_nrwrite_index_update writeback control flag
References: <20100524223544.GA13721@kroah.com> <20100524223016.208581966@clark.site> <20100525111208.GA8779@infradead.org> <20100525165230.GA9154@suse.de> <4BFC024A.9090600@jaysonking.com> <20100525171222.GA3533@suse.de>
In-Reply-To: <20100525171222.GA3533@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2010 12:12 PM, Greg KH wrote:
> I've now dropped those next two ext4 patches.  If someone wants to get
> this bug fixed for the .27 tree, please feel free to send me the
> patches.

I'll nominate Ted's "ext4: Use our own write_cache_pages()" patch for
.27-stable when it hits mainline. If it is included in -stable, then
those last two ext4 patches can be re-applied.

> Personally, I doubt many people care about ext4 on the .27 kernel
> release...

In any case, 2.6.27 is a good kernel, and ext4 is a good FS, IMO.

Jayson


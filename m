Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0KSWuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:50:04 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:32302 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757181Ab0KSWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:50:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAOeN5kxLd/sX/2dsb2JhbAAHgz3MRJEHgSKDNnMEhFqLE4YI
X-IronPort-AV: E=Sophos;i="4.59,226,1288584000"; 
   d="scan'208";a="83025305"
Message-ID: <4CE6FF16.90701@teksavvy.com>
Date: Fri, 19 Nov 2010 17:49:58 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com> <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com> <20101119163013.GJ10039@thunk.org>
In-Reply-To: <20101119163013.GJ10039@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-19 11:30 AM, Ted Ts'o wrote:
>
> If there are some incompetently implemented SSD's out there which do a
> flash erase of the entire SSD upon receiving a TRIM command (new
> flash!  Part of the whole *point* of a TRIM was to increase write
> endurance by eliminating the need to copy blocks that really weren't
> in use any more by the OS when the SSD is doing a GC copy/compaction
> of a partially written flash sector), all I can do is do a sigh, and
> wish that T13 had defined a "comptently implemented SSD bit" --- not
> that Indilinix would admit if it they were incompetent.  :-/


The Sandforce drives seem even slower for mke2fs than the Indilinx.
And both types are faster than the Intel units for desktop use.
At least they optimized for the important commands.  :)

Cheers

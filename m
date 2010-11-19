Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0KSPfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:35:33 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:44184 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755019Ab0KSPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:35:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBALcn5kxLd/sX/2dsb2JhbAAHgz3MNpENgSKBU4FjcwSEWosThgg
X-IronPort-AV: E=Sophos;i="4.59,223,1288584000"; 
   d="scan'208";a="82987302"
Message-ID: <4CE69940.6040908@teksavvy.com>
Date: Fri, 19 Nov 2010 10:35:28 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Steven Whitehouse <swhiteho@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org>
In-Reply-To: <20101119140203.GC10039@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-19 09:02 AM, Ted Ts'o wrote:
>but that's why mount -o discard is not the default.


But, oddly, it _is_ the default for mke2fs -t ext4,
which really threw me for a loop recently.

I though my system had locked up when suddenly everything
went dead for a very long time (many minutes) while installing a new system.

Then I figured out what was going on.
I really believe that "-K" should be the _default_ for mke2fs,
as otherwise lots of other people probably also wonder
if Linux is killing their SSD at system install time..

Cheers

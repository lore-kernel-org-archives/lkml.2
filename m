Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0KSNyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:54:22 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:26385 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121Ab0KSNyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:54:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAIMQ5kxLd/sX/2dsb2JhbAAHgz3MIJELgSKDNnMEhFqLEw
X-IronPort-AV: E=Sophos;i="4.59,223,1288584000"; 
   d="scan'208";a="82976686"
Message-ID: <4CE6818A.9020608@teksavvy.com>
Date: Fri, 19 Nov 2010 08:54:18 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <4CE59C9E.6050902@teksavvy.com> <20101119110903.GA10944@infradead.org>
In-Reply-To: <20101119110903.GA10944@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-19 06:09 AM, Christoph Hellwig wrote:
> On Thu, Nov 18, 2010 at 04:37:34PM -0500, Mark Lord wrote:
>> Currently, I patch my kernels to remove the automatic online TRIMs.
>> Is there a knob somewhere for this in the later kernels?
>
> There is not automatic discard in any recent kernel.  You always need
> to mount with -o discard to enabled it.

Peachy.  Thanks, Christoph.

My 2-year old userspace here doesn't have "-o discard",
so I couldn't find it in the man pages etc.. thus my paranoia.  :)

Cheers

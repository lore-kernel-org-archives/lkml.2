Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675Ab0KRVpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:45:45 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:64940 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757205Ab0KRVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:45:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBACot5UxLd/sX/2dsb2JhbAAHgz3OSJB2gSKDNnMEhFqLEA
X-IronPort-AV: E=Sophos;i="4.59,218,1288584000"; 
   d="scan'208";a="82908475"
Message-ID: <4CE59E86.1080603@teksavvy.com>
Date: Thu, 18 Nov 2010 16:45:42 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Jamie Lokier <jamie@shareable.org>, Jeff Moyer <jmoyer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <20101118180557.GU22787@shareable.org> <20101118193255.GE1594@arch.trippelsdorf.de>
In-Reply-To: <20101118193255.GE1594@arch.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-18 02:32 PM, Markus Trippelsdorf wrote:
> On 2010.11.18 at 18:05 +0000, Jamie Lokier wrote:
>> Online trim may be slow, but offline would be awfully inconvenient
>> when an fs is big and needed for a live system, or when it's your root fs.
>
> You can call FITRIM from a running system. Infact I run it once per week
> as a cron job on my (mounted) root fs.


Ditto for wiper.sh.

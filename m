Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0HCQWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:22:45 -0400
Received: from daytona.panasas.com ([67.152.220.89]:11199 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755952Ab0HCQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:22:43 -0400
Message-ID: <4C58424C.1020208@panasas.com>
Date: Tue, 03 Aug 2010 19:22:36 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>, ngupta@vflare.org,
        akpm@linux-foundation.org, Chris Mason <chris.mason@oracle.com>,
        viro@zeniv.linux.org.uk, adilger@sun.com, tytso@mit.edu,
        mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V3 0/8] Cleancache: overview
References: <20100621231809.GA11111@ca-server1.us.oracle.com4C49468B.40307@vflare.org> <840b32ff-a303-468e-9d4e-30fc92f629f8@default 20100723140440.GA12423@infradead.org 364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default> <fc254547-5926-4cb9-98e1-7a79f7284e30@default>
In-Reply-To: <fc254547-5926-4cb9-98e1-7a79f7284e30@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2010 16:22:42.0504 (UTC) FILETIME=[19389C80:01CB3328]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2010 12:17 AM, Dan Magenheimer wrote:
>>> On Fri, Jul 23, 2010 at 06:58:03AM -0700, Dan Magenheimer wrote:
>>>> CHRISTOPH AND ANDREW, if you disagree and your concerns have
>>>> not been resolved, please speak up.
>>
>> Hi Christoph --
>>
>> Thanks very much for the quick (instantaneous?) reply!
>>
>>> Anything that need modification of a normal non-shared fs is utterly
>>> broken and you'll get a clear NAK, so the propsal before is a good
>>> one.
>>
>> No, the per-fs opt-in is very sensible; and its design is
>> very minimal.
> 
> Not to belabor the point, but maybe the right way to think about
> this is:
> 
> Cleancache is a new optional feature provided by the VFS layer
> that potentially dramatically increases page cache effectiveness
> for many workloads in many environments at a negligible cost.
> 
> Filesystems that are well-behaved and conform to certain restrictions
> can utilize cleancache simply by making a call to cleancache_init_fs
> at mount time.  Unusual, misbehaving, or poorly layered filesystems
> must either add additional hooks and/or undergo extensive additional
> testing... or should just not enable the optional cleancache.

OK, So I maintain a filesystem in Kernel. How do I know if my FS
is not "Unusual, misbehaving, or poorly layered"

Thanks
Boaz

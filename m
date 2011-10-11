Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1JKAH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:07:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1JKAH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <20111010165116.GX7948@thunk.org>
References: <1317004226.29510.172.camel@sli10-conroe>
	<20110926073025.GB21079@infradead.org>
	<1317022727.29510.175.camel@sli10-conroe>
	<20110926094554.GA30827@infradead.org>
	<1317179380.22361.8.camel@sli10-conroe>
	<20111010165116.GX7948@thunk.org>
Date: Tue, 11 Oct 2011 09:07:56 +0900
Message-ID: <CAKYAXd_Akk_9yNM-ZN=8hYM=0JEKSzzqXLjbQY9auPK0Qe6NoQ@mail.gmail.com>
Subject: Re: [patch]ext4: add block plug for .writepages
From: NamJae Jeon <linkinjeon@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Shaohua Li <shaohua.li@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/11 Ted Ts'o <tytso@mit.edu>:
> On Wed, Sep 28, 2011 at 11:09:40AM +0800, Shaohua Li wrote:
>> I searched a little bit, looks only ext4 need it. here is the patch.
>>
>>
>> Add block plug for ext4 .writepages. Though ext4 .writepages
>> already handles request merge very well, block plug is still
>> helpful to reduce block lock contention.
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
You found good point.
If there are other filesystem that didn't use generic_writepages,
these are needed as this patch.

Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
>
> Thanks, applied.
>
>                                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2GCLve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2GCLvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:51:33 -0400
Message-ID: <4FF2DCB1.2090704@redhat.com>
Date: Tue, 03 Jul 2012 13:51:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com,
        martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for discard_alignment
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com> <1341235225-27551-2-git-send-email-pbonzini@redhat.com> <20120703023442.GB3586@redhat.com>
In-Reply-To: <20120703023442.GB3586@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/07/2012 04:34, Vivek Goyal ha scritto:
>> > The next patches will actually use the alignment, expose it in sysfs
>> > for ease of debugging.
>> > 
> Don't we already have discard_alignment exported as device attribute.
> 
> /sys/block/<dev>/discard_alignment

Ah, interesting, I missed it completely.  I guess it's because queue/
directories only exist for full disks, and the correct alignment varies
for each partition.  So this patch is unnecessary.

Paolo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2AGCIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 21:08:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355Ab2AGCII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 21:08:08 -0500
Message-ID: <4F07A8E3.7010105@redhat.com>
Date: Sat, 07 Jan 2012 00:07:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-media@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com> <4F05DFF0.3000809@infradead.org> <CA+55aFyDJ5PJ75R_bSaV5KCpLANmNwCjCA=mYj4g+H+35NQSNQ@mail.gmail.com> <4F05F57A.2070007@infradead.org>
In-Reply-To: <4F05F57A.2070007@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-01-2012 17:09, Mauro Carvalho Chehab wrote:
> On 05-01-2012 15:47, Linus Torvalds wrote:
 
>> Can you test the patch with some media capture apps (preferably with
>> the obvious fix for the problem that Paulo already pointed out -
>> although that won't actually matter until some block driver starts
>> using ENOIOCTLCMD there, so even the unfixed patch should mostly work
>> for testing)?
> 
> Sure. I'm currently traveling, so I have just my "first aids kit" of devices
> but they should be enough for testing it. I'll return you as soon as I finish
> compiling the kernel on this slow 4 years-old notebook and run some
> tests with the usual applications.

I did a quick test today: didn't notice any regressions with the usual
applications.

Regards,
Mauro

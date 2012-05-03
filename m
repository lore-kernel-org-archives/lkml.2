Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2ECHsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2ECHsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:48:01 -0400
Message-ID: <4FA23809.2090905@redhat.com>
Date: Thu, 03 May 2012 09:47:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com>
In-Reply-To: <4FA18D33.3060607@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2012 21:38, Mark Lord ha scritto:
>> >
>> > Indeed, RHEL doesn't have the warning at all and blocks all ioctls
>> > including SG_IO (and in the past six months nobody has complained that
>> > something stopped working for them).  Never said the patch is perfect...
> hdparm.
> 

Breaking "hdparm --write-sector /dev/sda1"?  I call it a security fix.

Paolo

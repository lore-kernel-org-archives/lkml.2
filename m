Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2ECMvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab2ECMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:34 -0400
Message-ID: <4FA27E7C.6070802@redhat.com>
Date: Thu, 03 May 2012 14:47:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com> <4FA18D33.3060607@teksavvy.com> <4FA23809.2090905@redhat.com> <4FA27CDB.2080103@teksavvy.com>
In-Reply-To: <4FA27CDB.2080103@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/05/2012 14:40, Mark Lord ha scritto:
>> > 
>> > Breaking "hdparm --write-sector /dev/sda1"?  I call it a security fix.
> No, that would plain stupid on both our parts.  :)
> The --write-sector flag is allowed only for non-partitions by hdparm itself.

Excuse my laziness--how does it check?  Most programs I looked at check
at the shape of the file and some are even fooled by "ln -sf /dev/sda1
./sda".

> But other flags commonly used by distros at boot time
> seem to be triggering the current in-kernel noise.
> Dunno which flags, I'm just ignoring them and waiting
> for the noise message to get reverted.

That's exactly the behavior I hoped to get when I added the warnings.
Or maybe not. :)  What are the messages?  i.e. what ioctl do they
complain about?

Paolo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2EBTi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:38:29 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:24655 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2EBTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:38:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsUHACxOgk8Y9geI/2dsb2JhbAANNoVzsCSCBwEDAQOEHQEBAQEDI1UBEAsOCgICBRYLAgIJAwIBAgFFBg0BBwEBtCSKGIEvjhOBGASpJQ
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="178100977"
Message-ID: <4FA18D33.3060607@teksavvy.com>
Date: Wed, 02 May 2012 15:38:27 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502115447.7dcc3a54@pyramind.ukuu.org.uk> <4FA11454.2010103@redhat.com> <20120502121208.3c19a9bc@pyramind.ukuu.org.uk> <4FA11963.3040007@redhat.com>
In-Reply-To: <4FA11963.3040007@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-02 07:24 AM, Paolo Bonzini wrote:
>
> Indeed, RHEL doesn't have the warning at all and blocks all ioctls
> including SG_IO (and in the past six months nobody has complained that
> something stopped working for them).  Never said the patch is perfect...

hdparm.


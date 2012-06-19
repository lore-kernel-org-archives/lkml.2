Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2FSSAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:00:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33683 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2FSSAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <4FDFDDBE.3050506@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
	<1340002390-3950-2-git-send-email-asias@redhat.com>
	<20120618213103.GC32733@google.com>
	<4FDFDDBE.3050506@redhat.com>
Date: Tue, 19 Jun 2012 11:00:51 -0700
X-Google-Sender-Auth: cf5jps3FB-n11KODdAKcfjJKHw0
Message-ID: <CAOS58YOzQ-fgLMCBYC=1zg=mXTmb96YcueNc3pu+ZLZVo1Xj7Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: Introduce __blk_segment_map_sg() helper
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 18, 2012 at 7:02 PM, Asias He <asias@redhat.com> wrote:
>> I *hope* this is a bit prettier.  e.g. Do we really need to pass in
>> @sglist and keep using "goto new_segment"?
>
> I think this deserves another patch on top of this splitting one. I'd like
> to clean this up later.

Yeap, doing it in a separate patch would be better. It would be great
if you can include such patch in this series. :)

Thanks.

-- 
tejun

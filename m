Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0DJCea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 22:34:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0DJCe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 22:34:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YxSE0MSHyiX5UGdI/hlqdBqO40vzf81JlrY8C9mgsgj+Ue4G4FduHTqMKd56MizPE
	s8XCSDc5LC1q8NGbY+ioA==
MIME-Version: 1.0
In-Reply-To: <20100409153255.GA3722@redhat.com>
References: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com> 
	<20100409041428.23105.51779.stgit@austin.mtv.corp.google.com> 
	<20100409153255.GA3722@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 9 Apr 2010 19:34:05 -0700
Message-ID: <k2qaf41c7c41004091934uaf6e6d1eg20386fd4a978d88a@mail.gmail.com>
Subject: Re: [PATCH 2/3] blkio: Add io_queued and avg_queue_size stats
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 8:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> +void blkiocg_update_request_add_stats(struct blkio_group *blkg,
>> +                     struct blkio_group *curr_blkg, bool direction,
>> +                     bool sync)
>> +{
>
> curr_blkg is redundant?

Missed this comment in my earlier response. No, curr_blkg is not
redundant since it is used for determining whether we should set
group_wait_time or not. This argument should really have been added in
the 3rd patch instead of this one. Unless you really want me to, I'd
just let it be.

-Divyesh

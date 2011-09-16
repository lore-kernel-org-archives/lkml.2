Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1IPI27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:28:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab1IPI25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:28:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=m+uKIVOHg3Bfd8Z9Jj4VAVAMhV/nrFLt+ZFroG+AcbDDuTnG2kPl2ibTNdYPjUuzJ
	g+sUUa3I8WlBL8qV3N1/Q==
MIME-Version: 1.0
In-Reply-To: <20110916081700.GC10741@zhy>
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
 <4E72FD93.2060805@google.com> <20110916081700.GC10741@zhy>
From: Paul Turner <pjt@google.com>
Date: Fri, 16 Sep 2011 01:28:25 -0700
Message-ID: <CAPM31RKJo1x04bms2hZvpNX5S45hnz8RmFw80nKqDecLwDWuAw@mail.gmail.com>
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Wang Xingchao <xingchao.wang@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> But it looks ok on my side.
> And on LKML: https://lkml.org/lkml/2011/9/16/11
>

Yeah looks like my client mangled it -- no idea H-T-F it accomplished that,

Sorry,

- Paul

> So maybe it's not Xingchao's problem.
>
> Thanks,
> Yong
>
>>

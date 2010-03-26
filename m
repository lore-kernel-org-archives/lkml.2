Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0CZDZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:25:05 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45161 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0CZDZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=TbTat6RDicdnrFkjfLRpE9HiqAVo1VmiK3yV5sQfY2yDrD39d6wFk59/6/YyJkjz7a
         woMFj10D5sEp68P+3zcGF5+2/vob3zJ9FhEzpfJafD6jxVx0kBV5nss0vwcuJbjTSQ4v
         mLXNwNKDZFxy+WxuuEJmjVpzIBvDyMCPXtNYI=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <adapr2t1xm8.fsf@roland-alpha.cisco.com>
Date: Fri, 26 Mar 2010 04:24:56 +0100
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <7AA94EEA-D9D7-4979-B9B2-890EF651D7C6@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <20100323180002.GA2965@elte.hu> <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com> <adapr2t1xm8.fsf@roland-alpha.cisco.com>
To: Roland Dreier <rdreier@cisco.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 24, 2010, at 5:40 PM, Roland Dreier wrote:

>> I will apply this commits to 2.6.32, I afraid current OFED (which I
>> need also) will not work on 2.6.33+.
> 
> What do you need from OFED that is not in 2.6.34-rc1?

I didn't go too 2.6.34-rc1.
I tried 2.6.33, mlx4 driver which comes with kernel produces panic on my hardwire. And OFED-1.5 doesn't support this kernel (probably it still can be compiled, didn't check).

Anton.


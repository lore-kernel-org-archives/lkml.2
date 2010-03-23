Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0CWSZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:25:50 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:57469 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0CWSZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=f8BEa2WKuNXFx4Rmj7Dy+pDj3ourODRSZHZXDslVvdLr/+MWJaF9vl1fcsulLuDkKd
         683rTCvxfLO/rduRtNUu343Xx/hnjS1Orv+ZuNNIGy+hxf5+hq4oysgQcjSF5DiDiU5W
         m3TD5k9TetNNxhx8wOWQ20u2QWNmzeyEwDHnE=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <20100323112141.7f248f2b.akpm@linux-foundation.org>
Date: Tue, 23 Mar 2010 19:25:43 +0100
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <41DAB29F-59B7-4D38-A389-75FAC47225BF@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <20100323180002.GA2965@elte.hu> <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com> <20100323112141.7f248f2b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 23, 2010, at 7:21 PM, Andrew Morton wrote:
>> I will apply this commits to 2.6.32, I afraid current OFED (which I need also) will not work on 2.6.33+.
>> 
> 
> You should be able to simply set CONFIG_RWSEM_GENERIC_SPINLOCK=n,
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y by hand, as I mentioned earlier?

Hm. I tried, but when I do "make oldconfig", then it gets rewritten, so I assume that it conflicts with some other setting from default fedora kernel config. trying to figure out which one exactly.

Anton.
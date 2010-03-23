Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0CWTa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:30:28 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:44393 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0CWTaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=U3/S4kKBI60WfhbWC+EXnAgJ9fEWex5dZ+AeYTm+ITHxzRobuwnOfJPVJGdL3eHCgr
         wsmozxcsQwnghyzabvGiwcroeQK50BtlKBFZJCofYSEslIe6q7RyR7D2MHz59mvMT3mR
         oCJm/MGLwvW2bbYVJLbTmkv0U4RIa8lf9GYXc=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <20100323192213.GA6169@sgi.com>
Date: Tue, 23 Mar 2010 20:30:19 +0100
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <C9A1C753-6105-460E-8E5C-828CC21F8113@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <20100323180002.GA2965@elte.hu> <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com> <20100323112141.7f248f2b.akpm@linux-foundation.org> <41DAB29F-59B7-4D38-A389-75FAC47225BF@gmail.com> <20100323192213.GA6169@sgi.com>
To: Robin Holt <holt@sgi.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 23, 2010, at 8:22 PM, Robin Holt wrote:

> On Tue, Mar 23, 2010 at 07:25:43PM +0100, Anton Starikov wrote:
>> On Mar 23, 2010, at 7:21 PM, Andrew Morton wrote:
>>>> I will apply this commits to 2.6.32, I afraid current OFED (which I need also) will not work on 2.6.33+.
>>>> 
>>> 
>>> You should be able to simply set CONFIG_RWSEM_GENERIC_SPINLOCK=n,
>>> CONFIG_RWSEM_XCHGADD_ALGORITHM=y by hand, as I mentioned earlier?
>> 
>> Hm. I tried, but when I do "make oldconfig", then it gets rewritten, so I assume that it conflicts with some other setting from default fedora kernel config. trying to figure out which one exactly.
> 
> Have you tracked this down yet?  I just got the patches applied against
> an older kernel and am running into the same issue.

I decided to not track down this issue and just applied patches. I understood that with this patches there is no need to change this config options. Am I wrong?

Anton
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0CXADP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:03:15 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50987 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0CXADO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=XnYVr5NU+C9bsjl0IlboenMi1u/u+iqD8juTP+7S7GqiLi6K+2ibh5mmQz7h6pH+n7
         XRL4Zb8VJQsWES2x9wTNWbmAHcQHs49yYCTolxMcVgpZRUTNGENaWNzuKclRewMq64N3
         kwXuhnw11PishWOPOJYbgMg8YBsSPHVjWvKE8=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1003231653260.18017@i5.linux-foundation.org>
Date: Wed, 24 Mar 2010 01:03:09 +0100
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <5D95EFF7-F924-4B0D-8B05-0D85697E315D@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com> <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org> <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com> <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org> <20100323233640.GA16798@elte.hu> <alpine.LFD.2.00.1003231653260.18017@i5.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it is included into my list.
When I will submit it into stable, I will include it also.

Anton

On Mar 24, 2010, at 12:55 AM, Linus Torvalds wrote:

> 
> 
> On Wed, 24 Mar 2010, Ingo Molnar wrote:
>> 
>> We havent had any stability problems with them, except one trivial build bug, 
>> so -stable would be nice.
> 
> Oh, you're right. There was that UML build bug. But I think that was 
> included in the list of commits Anton had - commit 4126faf0ab ("x86: Fix 
> breakage of UML from the changes in the rwsem system").
> 
> 		Linus


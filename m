Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0CWSDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:03:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:31672 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0CWSDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=RVoC46BtSzQbOprZ44UZsusu7LIG5eAlV1rdQNDcc3JwFffEzSJyhdNqqyrfUUkBMh
         90V71UOBxlNYyPvs1DEVjfrcrFfsQwdycIfgOw98W3tiptjjp2hNcj03a2QSUNLYnRsN
         7RCmw28mA0BlnyOqeObpFcRHnwesUbxGikyJw=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <20100323180002.GA2965@elte.hu>
Date: Tue, 23 Mar 2010 19:03:36 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <15090451-C292-44D6-B2BA-DCBCBEEF429D@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <20100323180002.GA2965@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 23, 2010, at 7:00 PM, Ingo Molnar wrote:
>> NOTE! None of those are in 2.6.33 - they were merged afterwards. But they 
>> are in 2.6.34-rc1 (and obviously current -git). So Anton would have to 
>> compile his own kernel to test his load.
> 
> another option is to run the rawhide kernel via something like:
> 
> 	yum update --enablerepo=development kernel
> 
> this will give kernel-2.6.34-0.13.rc1.git1.fc14.x86_64, which has those 
> changes included.

I will apply this commits to 2.6.32, I afraid current OFED (which I need also) will not work on 2.6.33+.

Anton.
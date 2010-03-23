Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0CWS06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:26:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0CWS05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=KPO5aLHAat9LDiRG9p/s4QQ9CcyKMM3zdBW230pBZpd49/3v6kVv/KErGydapWopN4
         9k+r0tHfOJcZNj98mWwESkgRrMVT4UaJSR9wAx5JXEjyCavf2/K0HKrCgw5+wUvR/CvX
         QVG46cf3MuekvG/M0MqzzNovlo0U3JMKdPQzw=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <20100323111351.756c8752.akpm@linux-foundation.org>
Date: Tue, 23 Mar 2010 19:19:22 +0100
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <1BAC48C3-2AF2-4FA2-9762-85727068BF64@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <20100323111351.756c8752.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 23, 2010, at 7:13 PM, Andrew Morton wrote:
> Anton, we have an executable binary in the bugzilla report but it would
> be nice to also have at least a description of what that code is
> actually doing.  A quick strace shows quite a lot of mprotect activity.
> A pseudo-code walkthrough, perhaps?


Right now can't say too much about the code (we just gave a chance to neighbor group to run their code on our cluster, so I'm totally unfriendly with this code). I will forward your question to them.

But probably right now you can get more information (including sources) here http://fmt.cs.utwente.nl/tools/ltsmin/

Anton
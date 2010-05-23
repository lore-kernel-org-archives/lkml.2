Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0EWRvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 13:51:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61429 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab0EWRvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 13:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=e6DDvArUShljZXb7j1DC/EFJ/I4/eJwDuIyAtj2KLW5Qb73gbfiO5EDQ/iQP6aS/yi
         IL1NQS+7TS/FUk7B1JoQdcCKZru281Jd9W1Byz1VO5hGxBpEKtC2MN/KGVuKjqj2/RIn
         H2TQi9MxQ0e4s+YsrgZYVDfcsKehl82JRWNDw=
Message-ID: <4BF96B00.5060905@gmail.com>
Date: Sun, 23 May 2010 19:50:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.4 Thunderbird/3.1b2
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com>	<20100521210729.GC2495@tuxdriver.com>	<4BF6F959.5040401@example.com>	<4BF6FBB0.6060407@example.com> <20100521151203.f94c1d3e.rdunlap@xenotime.net> <4BF7073A.4090506@example.com> <4BF7986C.4030505@example.com> <4BF7D185.2040705@example.com> <4BF7D86B.3020204@example.com> <4BF7DDAA.1080307@gmail.com> <4BF7DEE7.9010801@example.com> <4BF7DFDA.3000604@gmail.com> <4BF7E470.6080409@example.com> <4BF7E769.1090102@gmail.com> <4BF93392.7010803@example.com>
In-Reply-To: <4BF93392.7010803@example.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 03:54 PM, Piotr Hosowicz wrote:
> And they had built flawlessly. But main build with make-kpkg
> kernel_image nevertheless still fails. I don;t know what to do. I don't
> want to do those strace's, because it will take awfully long.

Why don't you just look at the actual error which is likely somewhere
above because of parallel build? And when you are posting outputs, first
switch your locale to en so that we can parse the output.

-- 
js

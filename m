Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1HRLgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:36:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42422 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755198Ab1HRLgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:36:53 -0400
X-Authenticated: #3035711
X-Provags-ID: V01U2FsdGVkX18QwP8+jmMQyIxHQQINqMsNDNJsC24pmZgEaOgyGt
	ayvAJ095gf15hg
Message-ID: <4E4CF94B.4010803@gmx.de>
Date: Thu, 18 Aug 2011 13:36:43 +0200
From: Ingo van Lil <inguin@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090320 Fedora/2.0.0.21-1.fc10 Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Stanislav Meduna <stano@meduna.org>, linux-kernel@vger.kernel.org,
        gunnarlindroth@hotmail.com,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] Floating point problems on UML - help needed
References: <4E4C2B6F.7000800@nod.at> <4E4CB13C.7010502@meduna.org> <4E4CED56.1030100@nod.at>
In-Reply-To: <4E4CED56.1030100@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/08/2011 12:45, Richard Weinberger wrote:

>> You might try the patch posted in
>> http://thread.gmane.org/gmane.linux.uml.devel/12158
>> (I don't have the environment to test it anymore)
>
> Cool, saving the FP registers explicitly on each task switch solves the
> issue.
> Do you know why Ingo's patch was never applied?
> Ingo?

I don't know why it was never applied, I guess it just slipped between 
the cracks. I've been using the patch for several months back in 2009, 
and it reliably fixed the observed problems.

My employer switched from UML to QEMU/KVM since then, so I eventually 
lost interest.

Cheers,
Ingo

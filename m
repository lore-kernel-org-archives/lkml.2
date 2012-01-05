Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2AEP2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:28:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45962 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab2AEP2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:28:49 -0500
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Thu, 05 Jan 2012 07:27:34 -0800
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <cb775851-f769-4df0-a510-02325abbaae2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I think it is probably Just A Bug.  Unless it can be shown it makes it much slower, let's fix.

Jan Beulich <JBeulich@suse.com> wrote:

>Forever these two functions have been limited to deal with at most 4G
>at a time. While I cannot point out an in-tree user that would require
>larger sizes, it is now the second time that within our Xen kernel we
>got
>bitten by that limitation. Would you nevertheless accept a patch to
>eliminate those shortcomings (iirc there may need to be workarounds
>for CPU bugs when it comes to using string instructions on such large
>blocks, albeit memmove() doesn't seem to care)?
>
>Otherwise, is there any rationale for this sort of lurking bug?
>
>Thanks, Jan

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

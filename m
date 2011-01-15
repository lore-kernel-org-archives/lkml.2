Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1AOLLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 06:11:45 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38834 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366Ab1AOLLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 06:11:44 -0500
X-Sasl-enc: kCJBopS6KkQ+AnemTkyn88DCgwYkJbrspG9dVEnE3Jl2 1295089904
X-User-Agent: K-9 Mail for Android
References: <1295005980-12297-1-git-send-email-viresh.kumar@st.com> <4D304BE6.9070200@fastmail.fm> <4D306B4D.2080909@linux.intel.com> <4D309851.4020503@fastmail.fm> <4D30A05B.9050602@linux.intel.com>
In-Reply-To: <4D30A05B.9050602@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend] kernel/async.c: fixing compilation warnings
From: Jack Stone <jwjstone@fastmail.fm>
Date: Sat, 15 Jan 2011 11:11:38 +0000
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org
Message-ID: <36b8bc65-0f28-4730-84ee-6c03c6453cbe@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Arjan van de Ven" <arjan@linux.intel.com> wrote:

>On 1/14/2011 10:39 AM, Jack Stone wrote:
>> On 14/01/2011 15:27, Arjan van de Ven wrote:
>>> On 1/14/2011 5:13 AM, Jack Stone wrote:
>>>> rning: ‘calltime.tv64’ may be used uninitialized in this function
>>> which is clearly a.. gcc funny to be honest. it's a false positive
>by
>>> any stretch.
>>>
>> Agreed. Who should merge this?
>
>should it be?
>traditionally we have shied away for workarounds for false positives 
>from gcc.....

I don't mind. I thought that was what uninitalized_var() was for.

Thanks,

Jack


-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab0HPENn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:13:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55692 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0HPENm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:13:42 -0400
X-User-Agent: K-9 Mail for Android
References: <AANLkTikx35Sp0GR4c_REYGcZV4bMgS+T-1cugen45d58@mail.gmail.com> <1281683951-19814-1-git-send-email-dfeng@redhat.com> <4C65B327.8020605@zytor.com> <4C67CA15.3020109@redhat.com>
In-Reply-To: <4C67CA15.3020109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] kvm: fix poison overwritten caused by using wrong xstate size
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 15 Aug 2010 21:12:58 -0700
To: Avi Kivity <avi@redhat.com>
CC: Xiaotian Feng <dfeng@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <84bb5b95-4f65-4942-9619-93db51bf27ed@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feel free to add my ack.

"Avi Kivity" <avi@redhat.com> wrote:

>  On 08/14/2010 12:03 AM, H. Peter Anvin wrote:
>> Avi, do you want to take this one or should I?
>
>I will, thanks.
>
>-- 
>error compiling committee.c: too many arguments to function
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.

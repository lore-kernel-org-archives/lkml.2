Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0HOQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:16:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab0HOQQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:16:53 -0400
Message-ID: <4C67CA15.3020109@redhat.com>
Date: Sun, 15 Aug 2010 14:05:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Xiaotian Feng <dfeng@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] kvm: fix poison overwritten caused by using wrong xstate
 size
References: <AANLkTikx35Sp0GR4c_REYGcZV4bMgS+T-1cugen45d58@mail.gmail.com> <1281683951-19814-1-git-send-email-dfeng@redhat.com> <4C65B327.8020605@zytor.com>
In-Reply-To: <4C65B327.8020605@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/14/2010 12:03 AM, H. Peter Anvin wrote:
> Avi, do you want to take this one or should I?

I will, thanks.

-- 
error compiling committee.c: too many arguments to function


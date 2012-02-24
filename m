Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2BXEe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:34:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59013 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab2BXEe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:34:27 -0500
Message-ID: <4F471344.1010002@zytor.com>
Date: Thu, 23 Feb 2012 20:34:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andy Lutomirski <luto@amacapital.net>, Amit Shah <amit.shah@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com> <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com> <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com> <4F3D2C09.1020803@redhat.com> <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com> <4F3D395B.1000708@redhat.com> <CALCETrXjJtKLhe2rRkuy57Ai+5X2-+qh9eMbE5y-UhX=CPWftA@mail.gmail.com> <4F3D3F59.80807@redhat.com>
In-Reply-To: <4F3D3F59.80807@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 09:39 AM, Avi Kivity wrote:
>>
>> Yes, this is on purpose

Why?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab1ADJs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:48:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab1ADJs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:48:56 -0500
Message-ID: <4D22ECFC.3040103@redhat.com>
Date: Tue, 04 Jan 2011 11:48:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sedat Dilek <sedat.dilek@googlemail.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, riel@redhat.com, mtosatti@redhat.com,
        gleb@redhat.com, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com> <4D224169.3050905@zytor.com>
In-Reply-To: <4D224169.3050905@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 11:36 PM, H. Peter Anvin wrote:
> On 01/02/2011 03:01 PM, Sedat Dilek wrote:
> >   arch/x86/kernel/kvm.c |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
>
> Avi, I'm presuming this is yours?

Yes.  Marcelo has kvm.git this week, he'll pick it up.

-- 
error compiling committee.c: too many arguments to function


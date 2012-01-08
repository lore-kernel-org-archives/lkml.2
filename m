Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2AHOIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:08:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2AHOIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:08:16 -0500
Message-ID: <4F09A344.8020000@redhat.com>
Date: Sun, 08 Jan 2012 16:08:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il> <E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com> <4F08AA3C.9090306@zytor.com> <C814BCA3-145A-410F-8F4F-CE5617DDB1A2@gmail.com> <20120108102657.9a5dd6534ea4ae829073ff6e@gmail.com> <CAKLkAJ4=eT7TdZoOkQKMnhmrESq5kvCQL3Mw52a35gu2yWsNgw@mail.gmail.com> <4F09A2A0.1060801@redhat.com>
In-Reply-To: <4F09A2A0.1060801@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2012 04:05 PM, Avi Kivity wrote:
> >
> > Avi, please acknowledge adding OpImm64.
>
> Yes, OpImm64 is the cleanest IMO.  Note it doesn't even cost us a bit.

Note, usually I'd ask for a unit test to accompany the fix, but the
current framework only supports testing instructions that have a memroy
operand.  So you're off the hook for now, unless you'd like to extend
the framework.

-- 
error compiling committee.c: too many arguments to function


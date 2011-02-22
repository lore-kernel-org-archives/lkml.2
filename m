Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1BVOB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:01:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1BVOB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:01:57 -0500
Message-ID: <4D63C1CF.9000208@redhat.com>
Date: Tue, 22 Feb 2011 16:01:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/6] KVM: SVM: Advance instruction pointer in dr_intercept
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com> <1297272584-22689-2-git-send-email-joerg.roedel@amd.com> <20110222111408.GH16508@amd.com>
In-Reply-To: <20110222111408.GH16508@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 01:14 PM, Roedel, Joerg wrote:
> On Wed, Feb 09, 2011 at 12:29:39PM -0500, Joerg Roedel wrote:
> >  In the dr_intercept function a new cpu-feature called
> >  decode-assists is implemented and used when available. This
> >  code-path does not advance the guest-rip causing the guest
> >  to dead-loop over mov-dr instructions. This is fixed by this
> >  patch.
> >
>
> Btw. Can you meanwhile apply this patch? It fixes a bug which sends the
> guest into an endless loop when decode assists is available on the host.

Yes of course - should have done that myself.  Applied now, and queued 
for 2.6.38.

-- 
error compiling committee.c: too many arguments to function


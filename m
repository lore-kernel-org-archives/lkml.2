Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1DCKRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:17:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60100 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1DCKRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=q+4jkPBH21y/OgzNU5pFExf5QA1i9BZlDT//q8LBgb9NLMxvLtESvSFBL0WiQ8+RyD
         12fdQ56TWA+Pzt37xJap5C0nW3Wf9cVwgsM6+r40pEYS6Rd3yrk+gW6RT2Cw6YXfVY3U
         MowwH24NVKS/8WGwqOxLOSsUQGQ0B7GgGVKqo=
MIME-Version: 1.0
In-Reply-To: <4D9847BC.9060906@redhat.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
Date: Sun, 3 Apr 2011 13:17:53 +0300
X-Google-Sender-Auth: Utr67rlpm0aeL4sFm1DxLlyXAdo
Message-ID: <BANLkTik5-ohx47AyLz_mJkCqNtO4uKVBew@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Sun, Apr 3, 2011 at 1:11 PM, Avi Kivity <avi@redhat.com> wrote:
>> SMP, networking, and simpler guest to host communication from shell
>> are most interesting missing features for me.
>
> If it is to be more than a toy, then Windows (really generic guest) support,
> manageability, live migration, hotplug, etc. are all crucial.

It's definitely not a toy, it's my main virtualization tool of choice
for kernel development! ;-)

The features you mention are crucial for servers but not for desktop.
I personally don't have much need for managing and live-migrating
Windows guests but if someone is interested in working on that, we're
happy to take patches!

                        Pekka

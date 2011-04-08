Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1DHGvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:51:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44093 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1DHGvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v4AOXowO9um0k9QN7q7ZSv11W0nuDAbLVk1/orXt4Z29WUbbTU17+oLg8J2as/s63p
         42iAqbv8wstpgmcp6JWr0CUl2tzhFjhDLxOWgTAW1b3W78/pzg7oayvFOFH4AhXIgz5l
         ubRXqF7ophWUv9auv/il863MA8HNdFop02H68=
MIME-Version: 1.0
In-Reply-To: <20110408154712.8319bf74.yoshikawa.takuya@oss.ntt.co.jp>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
	<20110408154712.8319bf74.yoshikawa.takuya@oss.ntt.co.jp>
Date: Fri, 8 Apr 2011 09:51:09 +0300
X-Google-Sender-Auth: v4w5rnmowwDgYGWJEc2ngytP-eA
Message-ID: <BANLkTi=XhcmpNkOa2QffBCuZOZfTZZaqvA@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takuya!

On Fri, Apr 8, 2011 at 9:47 AM, Takuya Yoshikawa
<yoshikawa.takuya@oss.ntt.co.jp> wrote:
> Is it possible to find the code maintenance policy on a project site
> or somewhere?  -- for both short run and long run.
>
> I may get some interest in using this tool for my debugging/testing/
> self-educational porpuses, but cannot know what I can do/expect.

Heh, it's all pretty straight-forward. Fetch the sources from this tree:

 git clone git://github.com/penberg/linux-kvm.git

Find something interesting to hack on and when you have something you
want integrated send patches to penberg@kernel.org and CC this list.
That's it!

In the long run, we hope to live in the main kernel tree under
tools/kvm and be part of the regular kernel release cycle.

                       Pekka

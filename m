Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1FBOxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:53:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44622 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1FBOxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Mzw2sI3sCx2+/ITMFHAtLTO7HihfyU+Bqasj3SzLmd4Y7x7MyLNPflVUnBh4dvGDER
         qvCxgeXhEID8qPeNudW8eNXbD2ln3x4dm76N2o9bPTui8RvEeH2q3V/v8yNp2DGhV6B8
         yJqsKircHIxlVHltIvH2IJsLDiBOe8DMAUFzg=
MIME-Version: 1.0
In-Reply-To: <4DE55AE9.90505@fb.com>
References: <1306869046-20172-1-git-send-email-asharma@fb.com>
 <1306869046-20172-2-git-send-email-asharma@fb.com> <BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com>
 <4DE55AE9.90505@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 2 Jun 2011 10:53:18 -0400
Message-ID: <BANLkTi=nKqwFKt8boNHQ=imgEz0fdyGCqw@mail.gmail.com>
Subject: Re: [PATCH 2/2] atomic: move atomic_add_unless to generic code
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 17:17, Arun Sharma wrote:
> On 5/31/11 1:21 PM, Mike Frysinger wrote:
>> On Tue, May 31, 2011 at 15:10, Arun Sharma wrote:
>>>
>>> This is in preparation for more generic atomic
>>> primitives based on __atomic_add_unless.
>>
>> i think you might have to have those primitives in place before this
>> patch makes sense.  the only thing this does is hoist a single
>> comparison out of arch atomic.h's and into linux/atomic.h.  this
>> savings alone looks simply like over engineering to me.
>
> Some of the context is buried in the lkml-reference. The main motivation for
> the patch is commit 686a7e3.
>
> The idea is to move atomic_add_unless_return() into linux/atomic.h

my point is that that patchset doesnt seem to exist yet, and it'd
probably make sense to have it ready and part of this series before
attempting to push this.
-mike

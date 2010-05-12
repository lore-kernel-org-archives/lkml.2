Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0ELNqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:46:42 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50530 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0ELNqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sl5sk4hpqWjK2EsV1OG67zd3S6V/doXRXG6FG0teGb6la5v39rpjZa3Od/+xdw/DVv
         lE4A5qg7ISB36dzEnEfhK9sVRv88L+xxaS0n6Ha2A3vG4f2+717C06x+q3ZdNq3ekJ4x
         w48LLam4d8EL3t9fIRKsaUObzLiQzYm/7s3h4=
MIME-Version: 1.0
In-Reply-To: <1273671627.1626.116.camel@laptop>
References: <1273669541.3086.24.camel@localhost>
	 <1273671627.1626.116.camel@laptop>
Date: Wed, 12 May 2010 15:46:37 +0200
Message-ID: <AANLkTimJTqxagyHn0orcGtor_r8iOAfNpJQfGLGCETg8@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 3:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-05-12 at 15:05 +0200, Dhaval Giani wrote:
>> Where cpusets goes wrong is to have a *no* default values.
>
> It has a default, empty is still a valid value.
>

Well, it is still not sane. And in the part you snipped, I did mention,

>> do we enforce a policy to have sane defaults
>> for subsystems if they prevent attaching "regular" tasks by default.

And to add to it, a sane default can be defined as one, where a task
can be attached to a cgroup on creation without changing any other
parameter.

Dhaval

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1IMBhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:37:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49954 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1IMBhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <4E66EDBC.4040102@redhat.com>
References: <4E649986.5060606@redhat.com>
	<CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
	<4E66EDBC.4040102@redhat.com>
Date: Mon, 12 Sep 2011 21:37:15 -0400
Message-ID: <CACqU3MUojYPiDEPusZ0WU-PUAByO6yu02gYEj11W8QVNga-HFw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fix for 3.1-rc5
From: Arnaud Lacombe <lacombar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 7, 2011 at 12:06 AM, Avi Kivity <avi@redhat.com> wrote:
> On 09/07/2011 02:20 AM, Linus Torvalds wrote:
>>
>> On Mon, Sep 5, 2011 at 2:42 AM, Avi Kivity<avi@redhat.com>  wrote:
>> >  Linus, please pull from
>> >
>> >    git://github.com/avikivity/kvm.git kvm-updates/3.1
>> >
>> >  to receive a fix for a build failure due to a missing instruction size
>> >  suffix in inline assembly.
>>
>> Again, please give me a warm and fuzzy feeling that this is really
>> Avi, and the right thing to do, rather than just a "please pull from
>> this random tree".
>
> Yup, it's the genuine thing here, and the s/mul/mulq/ is not an incredibly
> clever backdoor.
>
>> It's not that I don't think you are you, but I want people to actually
>> *think* about what they are doing and sending me. When you give me a
>> kernel.org address, I know you have access to kernel.org, and that
>> makes me believe you are you. When you give me a github address, that
>> doesn't really mean anything.
>>
>
> Well, these days access to kernel.org proves a lot less than it used to,
> unfortunately.
>
How comes that companies who directly participate in the kernel
development[0] cannot setup servers that would host trees of their
employee ? In which case, kernel.org would just be a mirror for those
tree.

Thanks,
 - Arnaud

[0]: from the top of my mind, RedHat, SuSe/Novell, Canonical, IBM, Intel, ...

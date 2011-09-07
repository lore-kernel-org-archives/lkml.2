Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1IGBT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:19:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61773 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1IGBTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:19:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
References: <4E649986.5060606@redhat.com>
	<CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
Date: Tue, 6 Sep 2011 21:19:48 -0400
Message-ID: <CA+5PVA4qTNpHOpr0nC9VyGGg8hCT8OS6F35m_+s=C7QSYLVnMg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fix for 3.1-rc5
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 7:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Sep 5, 2011 at 2:42 AM, Avi Kivity <avi@redhat.com> wrote:
>> Linus, please pull from
>>
>>  git://github.com/avikivity/kvm.git kvm-updates/3.1
>>
>> to receive a fix for a build failure due to a missing instruction size
>> suffix in inline assembly.
>
> Again, please give me a warm and fuzzy feeling that this is really
> Avi, and the right thing to do, rather than just a "please pull from
> this random tree".
>
> It's not that I don't think you are you, but I want people to actually
> *think* about what they are doing and sending me. When you give me a
> kernel.org address, I know you have access to kernel.org, and that
> makes me believe you are you. When you give me a github address, that
> doesn't really mean anything.

To your point, I would think you want that regardless.  I certainly
don't mean to pile on the kernel.org guys, but it was compromised and
likely through a user account.  I'm confident that this is a very rare
occurrence, but it can happen again.  There was another somewhat high
profile hack earlier in the year against vendor-sec as well.

Maybe asking for some extra warm fuzzies from now on wouldn't be a
horrible idea as general practice.

I will now await a reply full of the cold pricklies.

josh

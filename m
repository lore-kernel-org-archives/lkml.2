Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab1IGEHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:07:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1IGEG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:06:58 -0400
Message-ID: <4E66EDBC.4040102@redhat.com>
Date: Wed, 07 Sep 2011 07:06:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fix for 3.1-rc5
References: <4E649986.5060606@redhat.com> <CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
In-Reply-To: <CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 02:20 AM, Linus Torvalds wrote:
> On Mon, Sep 5, 2011 at 2:42 AM, Avi Kivity<avi@redhat.com>  wrote:
> >  Linus, please pull from
> >
> >    git://github.com/avikivity/kvm.git kvm-updates/3.1
> >
> >  to receive a fix for a build failure due to a missing instruction size
> >  suffix in inline assembly.
>
> Again, please give me a warm and fuzzy feeling that this is really
> Avi, and the right thing to do, rather than just a "please pull from
> this random tree".

Yup, it's the genuine thing here, and the s/mul/mulq/ is not an 
incredibly clever backdoor.

> It's not that I don't think you are you, but I want people to actually
> *think* about what they are doing and sending me. When you give me a
> kernel.org address, I know you have access to kernel.org, and that
> makes me believe you are you. When you give me a github address, that
> doesn't really mean anything.
>
>

Well, these days access to kernel.org proves a lot less than it used to, 
unfortunately.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1IFXVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:21:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333Ab1IFXVh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <4E649986.5060606@redhat.com>
References: <4E649986.5060606@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Sep 2011 16:20:45 -0700
Message-ID: <CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fix for 3.1-rc5
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 2:42 AM, Avi Kivity <avi@redhat.com> wrote:
> Linus, please pull from
>
>  git://github.com/avikivity/kvm.git kvm-updates/3.1
>
> to receive a fix for a build failure due to a missing instruction size
> suffix in inline assembly.

Again, please give me a warm and fuzzy feeling that this is really
Avi, and the right thing to do, rather than just a "please pull from
this random tree".

It's not that I don't think you are you, but I want people to actually
*think* about what they are doing and sending me. When you give me a
kernel.org address, I know you have access to kernel.org, and that
makes me believe you are you. When you give me a github address, that
doesn't really mean anything.

                              Linus

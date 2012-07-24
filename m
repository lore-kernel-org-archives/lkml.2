Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2GXTFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:05:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55728 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2GXTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:05:02 -0400
MIME-Version: 1.0
In-Reply-To: <500D1573.3030406@redhat.com>
References: <500D1573.3030406@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:04:40 -0700
X-Google-Sender-Auth: 8wj1Uka_tCcuhNJ7YEAvvQzlbhU
Message-ID: <CA+55aFygKruOf1G5bjfE3mpvaMP3B7Eg3Hh2=HpMO=M8fDX=tw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 3.6 merge window
To: Avi Kivity <avi@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, this caused conflicts with the s390 and ppc trees. I think I fixed
them correctly, but the respective arch people really should take a
look.

                  Linus

On Mon, Jul 23, 2012 at 2:12 AM, Avi Kivity <avi@redhat.com> wrote:
> Linus, please pull from the repo and tag at:
>
>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.6-1
>
> to merge the KVM updates for the 3.5 merge window.

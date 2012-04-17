Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2DQKZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab2DQKZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:25:16 -0400
Message-ID: <4F8D44FC.5000009@redhat.com>
Date: Tue, 17 Apr 2012 13:25:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>  <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>  <4F6EEEC1.4030608@redhat.com>  <20120326213809.GA29788@bloggs.ozlabs.ibm.com>  <4F7191E8.7020804@redhat.com>  <20120330120107.GA28503@bloggs.ozlabs.ibm.com>  <4F784C4D.3000409@redhat.com> <1333314138.30734.17.camel@pasglop>  <4F796C18.2040209@redhat.com> <1333359979.30734.48.camel@pasglop>  <3BB9812B-6FE2-4370-9D55-D273364BFFD1@suse.de>  <4F8C1652.7000004@redhat.com> <1334617517.25353.17.camel@pasglop> <4F8D19D3.1060002@redhat.com> <4F8D391D.8080008@suse.de>
In-Reply-To: <4F8D391D.8080008@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 12:34 PM, Alexander Graf wrote:
>>> tree but his tree is in linux-next as well. There's no reason not to do
>>> that.
>>>
>>> That way, his next branch gets linux-next coverage whether it's in my
>>> tree or not, and I pull when I put the final powerpc-next together,
>>> which gives me a chance to do a quick vet "just in case" and sort out
>>> any major conflict before it all goes to Linus.
>>>
>> Sure, that works too.
> Or do like I do with Kumar for FSL stuff... his stuff gets pulled via my
>
> Sounds even easier to me. So how do I get my tree into linux-next?

Send a note to Stephen Rothwell (copied).

-- 
error compiling committee.c: too many arguments to function


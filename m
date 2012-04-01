Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2DAMiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab2DAMiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:38:50 -0400
Message-ID: <4F784C4D.3000409@redhat.com>
Date: Sun, 01 Apr 2012 15:38:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop> <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com> <4F6EEEC1.4030608@redhat.com> <20120326213809.GA29788@bloggs.ozlabs.ibm.com> <4F7191E8.7020804@redhat.com> <20120330120107.GA28503@bloggs.ozlabs.ibm.com>
In-Reply-To: <20120330120107.GA28503@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 03:01 PM, Paul Mackerras wrote:
> I just noticed that the branch you asked Linus to pull includes none
> of the patches that Alex sent you in the last batch, in the email with
> subject "[PULL 00/56] ppc patch queue 2012-03-15" sent on March 15,
> where he asked you to pull git://github.com/agraf/linux-2.6.git
> for-upstream.
>
> What happened?  Did they get lost in the re-signing, or is there some
> reason you thought they shouldn't go in?

That pull request was send three days before the merge window opened;
patches are supposed to cook for a while in -next before being merged,
especially large trees like that one.

-- 
error compiling committee.c: too many arguments to function


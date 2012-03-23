Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2CWDQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:16:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50882 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab2CWDQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <1332461414.2982.90.camel@pasglop>
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 20:15:59 -0700
X-Google-Sender-Auth: fcRFWdbqCyKAQa1WDcbZe_YB0B8
Message-ID: <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 5:10 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> That means that everything gets constantly rebased, and it makes life
> very much harder for us working with this.

Ben, thanks for pointing this out.

I will not be pulling this tree at all. It's pure and utter shit, and
I wonder how long (forever?) this has been going on.

The particular issue that upsets *me* is only indirectly the problem
Ben is mentioning. No, the thing that makes me go "uhhuh, no way in
*hell* should I pull this" is that you have apparently totally broken
all sign-offs.

Avi, you ABSOLUTELY MUST NOT rebase other peoples commits. That's a
total no-no. And one thing I notice when I look through the commits is
that you have totally broken the Signed-off-by: series in the process,
exactly because what you do is crap, crap, CRAP.

The sign-off chain should be very simple: the first person to sign off
should be the author, and the last person to sign off should be the
committer.

That's simply not true in your tree. Maybe because you have rebased
other peoples (Alexander's) commits? I see commits where the sign-off
ends with Alexander, but then the committer is you. WTF?

Fix your f*cking broken shit *now*.

I'm not pulling crap like this. And it makes me unhappy to realize
that this has probably happened a long time and I haven't even
noticed.

The whole "you MUST NOT rebase other peoples commits" is the thing
I've been telling people for *years* now. Why the hell is it still
going on?

                       Linus

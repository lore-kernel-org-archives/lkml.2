Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1G1C5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:57:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab1G1C5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1107281240330.4840@tundra.namei.org>
References: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org>
 <CA+55aFzhg+W86y7TNQ6iqFEibfy+L9irxEHLd9VOy2+mTdWTSA@mail.gmail.com> <alpine.LRH.2.00.1107281240330.4840@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jul 2011 19:57:26 -0700
Message-ID: <CA+55aFyyROrBFuwKTWkEWpe=iF=E68bQicQcBpTFrx6Bj2RaBw@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 3.1
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 7:42 PM, James Morris <jmorris@namei.org> wrote:
>
> Ok, but this conflict was in my subsystem.

.. but it was a conflict that came from the VFS subsystem changes.

So it was clearly a cross-subsystem conflict. The fact that the file
was in what you consider your subsystem IS TOTALLY IRRELEVANT. Because
clearly somebody ELSE considered the change that conflicted to be part
of THEIR subsystem!

See?

So by definition, if you get conflicts with something that has come
into my tree from somebody else, then it is a cross-subsystem
conflict. What file it happens in (and whether you consider it "your"
file or not) is entirely irrelevant - because the important part is
that two different maintainers worked on the same area. That's the
definition of 'cross-subsystem conflict'.

In contrast, if you merge two different branches that you yourself
maintain, and have conflicts there, that's an "internal" conflict as
far as maintenance is concerned. I don't particularly care about those
internal conflicts, but you might want to talk to the people you work
with if you have lots of them..

                      Linus

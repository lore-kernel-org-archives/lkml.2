Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2EUO1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:27:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55198 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab2EUO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:27:12 -0400
Date: Mon, 21 May 2012 09:27:00 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.2.18
Message-ID: <20120521142643.GA28118@burratino>
References: <1337608943.10262.10.camel@deadeye>
 <CAFLxGvzdyr08UjHy_85CeHV=bB2nzzTy0JOdgLFx6x3mwOasdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzdyr08UjHy_85CeHV=bB2nzzTy0JOdgLFx6x3mwOasdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

richard -rw- weinberger wrote:
> On Mon, May 21, 2012 at 4:02 PM, Ben Hutchings <ben@decadent.org.uk> wrote:

>> All users of the 3.2 kernel series should upgrade.
>
> Should or must?

Every stable update probably includes some fixes that are
security-relevant for someone.  That said, no one on this list has
volunteered to do the nontrivial work of categorizing them (and that
is not the purpose of this list anyway).  You're more likely to find
useful information from your distributor or from sources such as the
national vulnerability database.

Amazingly enough, the difference between "should" and "must" is not a
secret message but just a difference in diction between Ben and Greg.

"All users should upgrade" would generally mean that it is prudent for
all users to upgrade, rather than some particular subset of them
(e.g., users who have been experiencing build failures).

Kind regards,
Jonathan

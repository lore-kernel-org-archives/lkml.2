Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1AUR5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:57:06 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:38400 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754678Ab1AUR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:57:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LFk7HYUvOTBWwjjqDCQTuDk9/m1huulqgoHNJ0N3dZdPV9QqaYJ0sp4BscUKu0247cEu3oPA1IinjozQJ6qZ4QSvHp46sx1Uc9COmhWARn4g1jDhbOO4rbYKW6GdXuoT;
Date: Fri, 21 Jan 2011 09:56:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, Joe Perches <joe@perches.com>,
        Dima Zavin <dmitriyz@google.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110121095658.1ab623fe@jbarnes-desktop>
In-Reply-To: <20110121094827.41818a55@jbarnes-desktop>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	<AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	<1295571359.9236.53.camel@m0nster>
	<1295574085.4096.6.camel@Joe-Laptop>
	<1295575123.9236.54.camel@m0nster>
	<1295576730.4096.24.camel@Joe-Laptop>
	<1295624801.19880.13.camel@m0nster>
	<20110121094827.41818a55@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 09:48:27 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Fri, 21 Jan 2011 07:46:41 -0800
> Daniel Walker <dwalker@codeaurora.org> wrote:
> > This isn't what's happening tho. In maintainer land if someone forwards
> > you a patch then you leave the original author on the patch. They wrote
> > the patch and your just forwarding it on up the ladder. This isn't the
> > case with these patches.. I crafted each of the commit I have authorship
> > on, no one forwarded those commits to me. I'm not taking authorship
> > credit for any thing I didn't create, although I an giving credit to the
> > place which gave me the raw material which was Google. From my
> > experience this is how it's done in Linux ..
> 
> I don't know why you're even trying to defend this, just admit you were
> wrong and move on.
> 
> Trying to claim the author field for these patches for yourself is both
> misleading and vain.  You did not write the code and are therefore not
> the author, trying to conflate the author and commit fields in this way
> is so misguided I thought you must be trolling when I first saw this
> thread.
> 
> This is not "how it's done in Linux" at all.  In this case you're
> trying to act like a maintainer by collecting patches and forwarding
> them upstream, so you need to preserve authorship and the s-o-b chain.
> If you want to take responsibility for the code going forward, great,
> but don't pollute the logs with bogus author fields that imply you
> wrote the stuff in the first place.

That said, if you did significant work on these before committing them,
then you're right and I'm wrong.  It *is* fairly common for committers
to change things; and if the changes are significant enough, they claim
authorship and note the original author in the changelog.

So if that's the case here, I apologize, but I didn't see that
explained in any part of the thread I read.

-- 
Jesse Barnes, Intel Open Source Technology Center

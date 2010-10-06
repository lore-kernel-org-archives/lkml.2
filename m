Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0JFEOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:14:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab0JFEOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vmcMApXTWH94L5XKh8AItmhdFgeHdIHEgjcdmnBuox/Ol8Kjs38MthsJIAbVBcbJP2
         gpw+myQ20vAX8K+AdOCQ==
MIME-Version: 1.0
In-Reply-To: <4CABF4F3.7050002@zytor.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
	<1286265215-9025-4-git-send-email-walken@google.com>
	<4CABF4F3.7050002@zytor.com>
Date: Tue, 5 Oct 2010 21:14:12 -0700
Message-ID: <AANLkTi=+0i13JF552P7dF_JD+S10Lt8=+KySHdtg-Uex@mail.gmail.com>
Subject: Re: [PATCH 3/3] access_error API cleanup
From: Michel Lespinasse <walken@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 9:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I was going to put it into the x86 tree, but being part of a larger
> series it gets messy.

Yes. It's easy enough to reorder the patches, if we care about this
one making it into 2.6.36 ahead of the rest, but it does not seem like
a huge payoff either.

I figure barring any surprises, the series is likely to merge from -mm
tree to mainline in time for 2.6.37 ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

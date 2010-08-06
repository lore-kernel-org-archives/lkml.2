Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930Ab0HFSxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:53:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761703Ab0HFSxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <20100805213308.GA13744@kroah.com>
References: <20100805213308.GA13744@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 11:27:02 -0700
Message-ID: <AANLkTikzUaTAAu1GqBGqNtvmpfG3z5_HjOCQoVEh9NO9@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING merge for .36
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 2:33 PM, Greg KH <greg@kroah.com> wrote:
> Here's the big staging tree merge for the .36 kernel.
>
>  812 files changed, 106306 insertions(+), 33784 deletions(-)

Hmm. How did you generate that diff? It's not what I get. I get

 812 files changed, 107586 insertions(+), 35064 deletions(-)

which is sufficiently different that it makes me worry about what's going on.

I pulled it, because the shortlog matched, and it was all in staging
(except for that one x86 mshyperv line), but I just wonder..

                Linus

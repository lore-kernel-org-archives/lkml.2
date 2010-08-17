Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab0HQUqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:46:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62770 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0HQUqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=hrLsfO9o2CnrlXePtN0LLUvR70HGVEUNdxkMdT1ttof2cjdPBM6S80EL2kXCR4PQF8
         cYGlBSBy8HxQM9Wx9CfwFK96wu5T923Py8VHvyYe6Ei2AYHVZO0nFT/f9Vz4YfkG7GJh
         G4dzGZNF4kVBARqbwbEOXPyb3wmqSXgwkG4rk=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
	<AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
	<AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
Date: Tue, 17 Aug 2010 13:46:08 -0700
X-Google-Sender-Auth: -YCYgse33vO1D0jDW_Uz8fUCIVI
Message-ID: <AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:24 AM, Tony Luck <tony.luck@intel.com> wrote:
> ... but it isn't trivial
> for me to try this out (my systems are on an isolated lab network segment).

Setting up for "git pull" would have been messy - but "git grep" is
multi-threaded in newer versions of git. So I've set a loop to keep
running "git grep" over and over.  Load average is above 7, so
there must be some threading going on, even though I only see
one "git" process in "top(1)".  Seems to be running fine so far.

-Tony

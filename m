Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1LAAx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:53:59 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64683 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab1LAAx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:53:58 -0500
Date: Thu, 1 Dec 2011 01:53:42 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: rusty@ozlabs.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RGC PATCH 0/2] split file2alias using elf sections
Message-ID: <20111201005342.GA16378@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <87k46itcvg.fsf@rustcorp.com.au>
References: <87k46itcvg.fsf@rustcorp.com.au>
  <cover.1320408578.git.rubini@gnudd.com> <20111122192300.GA5052@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty, thankyou for your feedback.
I plan to make V2 tomorrow (it was planned much earlier).

> The table driven loop is nice and simple, though the E() macro is a bit
> contrived.

Yes, but we have long names and I wanted to avoid splitting lines.
I can make it ENTRY().
 
> The separation into separate files just to avoid merge issues is
> overkill and useless churn.  The conflicts are simple, and you've just
> moved themto conflicts in the Makefile.

Yes and no. Actually, I expect several new buses to appear over time,
and being separate files they can even be conditionally compiled based
on config. 

> We'd be better off putting the table in alphabetical order and stopping
> there.  Easy code, no tricks.

I see. I'm submitting two patches anyways, but you can pick one only.

Thanks
/alessandro

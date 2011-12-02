Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1LBImb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:42:31 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63814 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1LBIma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:42:30 -0500
Date: Fri, 2 Dec 2011 09:42:13 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: rusty@ozlabs.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, siglesia@cern.ch,
        manohar.vanga@cern.ch, dave.martin@linaro.org
Subject: Re: [RFC PATCH V2 0/1] making order in file2alias
Message-ID: <20111202084213.GA3415@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <87pqg7r8q9.fsf@rustcorp.com.au>
References: <87pqg7r8q9.fsf@rustcorp.com.au>
  <cover.1322781825.git.rubini@gnudd.com> <20111202000350.GA6507@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But splitting 15-line functions into separate files?  Less compact, less
> simple.

Personally, I'm more interested in the addition of new busses (as
drop-in files) than the split up of current ones. But I see your point.

>> >   step 1: create the ELF section so ENTRY() lines can leave the array
>> >           (and change name accordingly).
>> > 
>> >   step 2: each ENTRY() line can be moved just after the associated code
>> >           (this means that a new bus is just a single hunk, not 2 of them)
>> > 
>> >   step 3: I create the headers needed to move code and ENTRY in separate
>> >           files. This is some movement around, not trivial so it may
>> >           deserve a patch in itself.

> If you *really* want to use separate files, then this patch will let you
> do it.  You'll need to expose some stuff in a header though.

Fine with me. This is 1 and 2 of my list above. And the "need to
expose" is my step 3. So I agree with this.

thanks
/alessandro

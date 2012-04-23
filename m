Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2DWCUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:20:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59316 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DWCUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLpOyBuvZ3+Nfw1u0dojOX8kt-1TDJA+v-EWQuKPdh0A1w@mail.gmail.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
	<20120420150732.10596.9085.stgit@beardog.cce.hp.com>
	<CAP=VYLpOyBuvZ3+Nfw1u0dojOX8kt-1TDJA+v-EWQuKPdh0A1w@mail.gmail.com>
Date: Sun, 22 Apr 2012 21:20:35 -0500
Message-ID: <CADzpL0S04XTYoe4u7_WNgA6cw11uNw9uxiyyYCQ=cY-p-Z+sww@mail.gmail.com>
Subject: Re: [PATCH 14/17] hpsa: use new IS_ENABLED macro
From: Stephen Cameron <stephenmcameron@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.gates@hp.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 1:12 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Fri, Apr 20, 2012 at 11:07 AM, Stephen M. Cameron
> <scameron@beardog.cce.hp.com> wrote:
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>
>> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> You've not written a commit log, so I'm left guessing what the
> intended rationale is here.  COMPAT, X86 and PCI_MSI are
> I believe all bool, so why make this change?  To me it gives
> a misleading message that some level of modular awareness
> is needed here, when there really isn't any such need.

Well, I saw this commit go by: 69349c2dc01c489eccaa4c472542c08e370c6d7e

   Using IS_ENABLED() within C (vs.  within CPP #if statements) in its
   current form requires us to actually define every possible bool/tristate
   Kconfig option twice (__enabled_* and __enabled_*_MODULE variants).
   [...]

and so I kind of thought IS_ENABLED is the new way to do that sort of thing.

Perhaps I'm wrong about that.  Obviously the patch is not _needed_ for
things to work.

-- steve

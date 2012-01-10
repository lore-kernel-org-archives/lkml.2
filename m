Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2AJTMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:12:12 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57728 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664Ab2AJTMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:12:09 -0500
Message-ID: <1326222726.3264.41.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [GIT PULL] Next round of SCSI updates for 3.2 merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 13:12:06 -0600
In-Reply-To: <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
References: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
	 <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 10:36 -0800, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 2:19 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > The patch is available here:
> >
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git#scsi-misc
> 
> No it's not.
> 
> Please fix your crappy script.
> 
> First off, that '#' is wrong. It should be a space.
> 
> Secondly, "master.kernel.org" doesn't support ssh'ing into it any
> more, and can't be used the way you claim I should use it.
> 
> IOW, that thing should have been
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc
> 
> so please fix your script to do that,

OK, fixed and resent.  Thanks,

James



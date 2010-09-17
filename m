Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0IQBb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:31:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36048 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab0IQBbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:31:25 -0400
X-Sasl-enc: Ob+1pS+EF5skAY2z7R2LJtIJpdhXF/qrotze7dmkMHE9 1284687084
Subject: Re: [PATCH 04/12] BKL: Remove BKL from autofs4
From: Ian Kent <raven@themaw.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        autofs@linux.kernel.org
In-Reply-To: <4C926DFC.1090600@zytor.com>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
	 <1284659185-8942-5-git-send-email-arnd@arndb.de>
	 <4C9258C1.3060906@zytor.com> <201009161955.48854.arnd@arndb.de>
	 <4C926DFC.1090600@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 09:31:19 +0800
Message-ID: <1284687079.3083.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 12:20 -0700, H. Peter Anvin wrote:
> On 09/16/2010 10:55 AM, Arnd Bergmann wrote:
> > On Thursday 16 September 2010 19:49:53 H. Peter Anvin wrote:
> >> On 09/16/2010 10:46 AM, Arnd Bergmann wrote:
> >>> autofs4 uses the BKL only to guard its ioctl operations.
> >>> This can be trivially converted to use a mutex, as we have
> >>> done with most device drivers before.
> >>>
> >>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >>> ---
> >>>  fs/autofs4/root.c |   12 +++++++-----
> >>>  1 files changed, 7 insertions(+), 5 deletions(-)
> >>
> >> You may want to Cc: the maintainer, Ian Kent.
> > 
> > Ah, sorry about this. I looked at the wrong MAINTAINERS entry.
> > 
> > I also forgot to Cc you about autofs3, adding more to the confusion. ;)
> > 
> > Do you think the time has come to move autofs3 to drivers/staging
> > as we deprecate the BKL?
> > 
> 
> I'm leaving that up to Ian.  I have offered for years to just plain kill
> off autofs3.

Yeah, my bad, again.
Now I want to wait for David Howells VFS automount series, which we're
working on now, since that will be a significant change.

> 
> 	-hpa



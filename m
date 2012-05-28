Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2E1Ci4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 22:38:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35767 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850Ab2E1Ciz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 22:38:55 -0400
Message-ID: <1338172734.977.3.camel@joe2Laptop>
Subject: Re: [PATCH] [staging] bcm: Fix codingstyle problems
From: Joe Perches <joe@perches.com>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: Devendra Naga <devendra.aaru@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 27 May 2012 19:38:54 -0700
In-Reply-To: <CAKPrQY8O0=PQroL6vYOCATG3WUx1ChgqW9rFqhuY2G7Q7oj3WA@mail.gmail.com>
References: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
	 <CAKPrQY8O0=PQroL6vYOCATG3WUx1ChgqW9rFqhuY2G7Q7oj3WA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 22:30 -0400, Kevin McKinney wrote:
> Hi Devendra,
> 
> On Sun, May 27, 2012 at 4:54 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> > Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> > ---
> >  drivers/staging/bcm/Debug.h |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> I understand this is a simple change, but please add a descriptive
> change log to your patch for consistency.

Hello as well.

Devendra, sometimes the simpler change isn't the best change.
Consider converting some of these macros into functions.



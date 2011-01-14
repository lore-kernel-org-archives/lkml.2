Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1ANEsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:48:05 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:48707 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1ANEr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:47:58 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, keep the errno
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=jozto+CNwfSKu2_dGWXaRi5p=3dqQngMz7g24@mail.gmail.com>
References: <8406.1294976295@jrobl> <AANLkTi=jozto+CNwfSKu2_dGWXaRi5p=3dqQngMz7g24@mail.gmail.com>
Date: Fri, 14 Jan 2011 13:47:55 +0900
Message-ID: <9582.1294980475@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> Great, thank you very much. I just changed a few variable names but
> applied it. Would you please add you Signed-off-by: on patches from
> now on?

Yes, of course.
I am just not confident, and guessed you may take another approach.


> Good reviewing work. Are you finding these by review or testing? I
> think ltptests on an nfs mount should find this kind of bug... which I
> should do.

First, review. And then modify/test the filesystem which I am developing
(FS_REVAL_DOT is used).
Some of my mails are from the reviewing and modifying phase.
I am in my testing phase. Someday my fs ->d_revalidate will be gone, I
hope.

Anyway your vfs-scale work is great which you definetly spent big time
and effort I believe.


J. R. Okajima

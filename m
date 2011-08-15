Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1HOPfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:35:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720Ab1HOPfI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110815131853.GL4926@sgi.com>
References: <1313348706-16093-1-git-send-email-Jes.Sorensen@redhat.com>
 <CA+55aFw4-3o9rX5z3Jtnim5v3K2LhsGyAbXWVG-8iyeCBjGezA@mail.gmail.com>
 <4E483C88.8090709@redhat.com> <20110815131853.GL4926@sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Aug 2011 08:34:15 -0700
Message-ID: <CA+55aFyYn+c7beaBAFfpx1wX4WdcFnc-p7dNPWq-55P8cUVuww@mail.gmail.com>
Subject: Re: [PATCH] Remove name and email address as maintainer for SN2
To: Robin Holt <holt@sgi.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 6:18 AM, Robin Holt <holt@sgi.com> wrote:
>
> Why don't we just add me as the maintainer.  I can set up a script to
> compile and boot it once a week on a few common configs.  I think I
> already have that for testing the x86_64 drivers/misc/sgi-xp bits so it
> should be no significant increase in work.
>
> I will work today on getting the linux-altix@sgi.com mailing list working
> again if it is not already and then ensuring I am on that list.

Ok, just to be nice, I'd suggest you send me the patch to do that with
authorship and sign-off. In fact, maybe we can just combine it with
Jes' patch, and just have both of yours sign-off.

                     Linus

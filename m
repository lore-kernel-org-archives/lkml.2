Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab1AMUFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:05:52 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50039 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608Ab1AMUFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KWYSmmggh/T35eGD/NZRZBnqVm0G8sI0uQYokRE/EKFndjYMIm2Th1FMfXQimEYjE3
         tC2EZe5dfvzvxr5zYlttcnvLlSd9ic4dYMDmTVX7+W503Dq5MpB/dweLW7Wve8h0usx+
         vb2GDXj7uQVs2gLX/g747T/tnObwfnuoT2G6E=
MIME-Version: 1.0
In-Reply-To: <4D2F5353.3000400@fusionio.com>
References: <4D2F03A7.2030809@fusionio.com>
	<20110113192152.GA18217@agk-dp.fab.redhat.com>
	<AANLkTin8icx0cir8czy9snZ0wg=QovJ4HSZru4jYUoea@mail.gmail.com>
	<4D2F5353.3000400@fusionio.com>
Date: Thu, 13 Jan 2011 21:05:40 +0100
X-Google-Sender-Auth: C22A6O7GZ4007_Q7X0oEqHjWie0
Message-ID: <AANLkTi=VaaJr1b37yabEj-XTe1pRzcEg6OHLb1HbEES0@mail.gmail.com>
Subject: Re: [GIT PULL] core block bits for 2.6.38
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alasdair G Kergon <agk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 8:32 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> I see Tejun already posted a fix, but Milan says it does not work.
> Tejun, any  updates?

Hmmm... seems like I missed something.  Unfortunately, it's already a
bit too late here.  I'll get back to it tomorrow afternoon.  The issue
is mostly cosmetic so if it can wait a day or two I don't think
reverting is necessary.

Thank you.

-- 
tejun

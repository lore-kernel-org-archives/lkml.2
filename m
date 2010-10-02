Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab0JBR1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 13:27:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33865 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0JBR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 13:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m/ysSPBEIHMjS8dK6enTN8D7P6dzQBt6sRS5+WW7JyPJObj7EZFiysV1/l787Fyb+R
         TYmUQvEjmEVHbkeOgOxqynqaw6faX5Q+3m4EucOo7BiU1N7aaskfXzMIj5u5hy1EtRIq
         jTyCHZyHJbXwWf4L6gwCzWPZMOjm07/CxIMqE=
MIME-Version: 1.0
In-Reply-To: <4CA2CCC3.8010307@fusionio.com>
References: <1285710456-4435-1-git-send-email-richard@nod.at>
	<20100928150000.f007f43e.akpm@linux-foundation.org>
	<201009290013.11332.richard@nod.at>
	<20100928225202.GA30352@foursquare.net>
	<4CA275CE.6060401@fusionio.com>
	<20100929012945.GA3324@foursquare.net>
	<4CA2CCC3.8010307@fusionio.com>
Date: Sat, 2 Oct 2010 19:27:22 +0200
Message-ID: <AANLkTikU4b5si0bA0QTqZWROHQkknKuwRSrtu-dV-Vzq@mail.gmail.com>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Chris Frey <cdfrey@foursquare.net>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 7:21 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> I think we need to find the real fix here, just disabling merging
> is not a fix (it's just a nasty work-around for the real bug).
>

Jens,

Do you have an idea which parts of the code are buggy?

-- 
Cheers,
//richard

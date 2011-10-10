Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab1JJPO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:14:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63070 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1JJPO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:14:28 -0400
MIME-Version: 1.0
X-Originating-IP: [83.233.40.23]
In-Reply-To: <20111010075250.GY18470@longonot.mountain>
References: <1318225337-25438-1-git-send-email-pelle@windestam.se>
	<20111010075250.GY18470@longonot.mountain>
Date: Mon, 10 Oct 2011 17:14:27 +0200
Message-ID: <CAOdCkm1YNJ2xkVk+p1MTxX_e_5T8UM9Tz7mWE5v5JUhHOuenEg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: staging: rts_pstor fixed checkpatch warnings
From: Pelle Windestam <pelle@windestam.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 9:52 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This looked nicer in the original version.  I know that checkpatch
> complains but in the end, checkpatch is just a perl script.  It's
> less sentient than a squirrel.
>
> regards,
> dan carpenter
>

I have to agree with you on that, but I wasn't sure how strictly to
follow the checkpatch warnings. I'll happily resubmit the patch
without this change if nobody minds.

//Pelle

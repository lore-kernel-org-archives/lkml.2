Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0GFVUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 17:20:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63108 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0GFVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 17:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K+aGRnz4BahTEfwg3AoCfMxTZIZRyLCmT63542E0nx4SYUEc1tKkiOMtlUYt5n8kBB
         jGjq2B2m3YffQydq6OVFiEt4psoPBbiGfTKUimlVgCTkp5yNTogz4dHi4kYS/4/VRhXL
         2wLkxSV9bYeY4L1cpQp6ugqHmU5n+A7SLb22M=
MIME-Version: 1.0
In-Reply-To: <1278437850.5396.85.camel@dermezel>
References: <1278435198.5396.73.camel@dermezel>
	<AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
	<1278437850.5396.85.camel@dermezel>
Date: Tue, 6 Jul 2010 16:20:43 -0500
Message-ID: <AANLkTimoIXXR2kpv3Q45lIeqaUgIdqNtfQbyK5wPzd9Z@mail.gmail.com>
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in dt3155_drv.c
From: Aldo Cedillo <aldobrett11@gmail.com>
To: kagen101@gmail.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I presumed all issues would be incorporated into checkpatch.pl. I guess
> it isn't.
> I think the safest be here then would be to fix the script as to then
> have a single point of failure rather than interpretation and reference
> documentation in conjunction to the script.
>
> Regards,
>
> Joe

I think it's a good idea, I don't know thoroughly this script but I think
stuff like this one should be included in the script.
Regards,
Aldo Brett

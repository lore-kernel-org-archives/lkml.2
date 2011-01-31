Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1AaOVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:21:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65109 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1AaOV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iVYDTyNamkRF49jObIDSPA1obQru2Gn/jZLShIhjJIkhRaBe7VmnsjGK8JQTj7XsoY
         6lNM2CAja11jdlD7LG+9SDQDu1/59PuICVpPfURMxl/qcllCVkuyrLfqmP1gSeYi6+MU
         QVzXtF0pLtSokXnbjEoPINCMp600ozmQ6AFgw=
MIME-Version: 1.0
In-Reply-To: <20110131135218.GA12173@redhat.com>
References: <AANLkTikk7ZyMFKTP=WuZR5QhJoEdmpCRy9BW=FiE160z@mail.gmail.com>
	<20110131135218.GA12173@redhat.com>
Date: Mon, 31 Jan 2011 15:21:27 +0100
Message-ID: <AANLkTi=V5JEi8DWev+mHh8K30cc5xPsy5hr1zS+QND23@mail.gmail.com>
Subject: Re: Hard LOCKUP with 2.6.32.28 (maybe scheduler/tick related?)
From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

>
> Your attached 'crash' details had another stacktrace first.  That one
> shows the nmi_watchdog triggering because a spin_lock is spinning forever
> in 'd_real_path'.  I couldn't find that code in any upstream tree, then
> again I was too lazy to clone the stable trees.  So I don't know what the
> exact problem is, but if you look through the git history of 2.6.32.28 and
> revert things that relate to 'd_real_path', you can probably workaround
> the problem for now, until someone who knows that stuff better than me can
> give you a better answer.

Thanks for the pointer. The 'd_real_path' function is part of
grsecurity, i'll see if they
can help :-)

Regards,

Sebastian

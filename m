Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1BZXx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:53:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1BZXxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:53:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KUFJnK4hMIyVmTsMcGVdvltoz99qbV3A0GMGEsr98pwOe0UnQ1SuYOe72J4uWLakrS
         M3ILG1Iwl/zCpT0iWSBTb7SvhCs+J6NaL4DcB1xKHqo5yWUcu/L6UkHD5phhFEfu1vB6
         y7RM3/dlK5jpXtRA8trwfN6CsepEpvZgU1tro=
MIME-Version: 1.0
In-Reply-To: <4D698DF1.7060303@suse.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
	<AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com>
	<AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>
	<4D698DF1.7060303@suse.com>
Date: Sat, 26 Feb 2011 18:53:22 -0500
Message-ID: <AANLkTikaOA48YPrmukHsVg_njzWsLFEHK54fe0Mn6yUd@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 26, 2011 at 6:34 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> But this argument isn't really relevant. As with all of the other files
> listed in the defconfig_list, if it's missing (or can't be read), it
> will move on to the next one. Decompressing it first just makes things
> /more/ confusing since the initial message of 'defaults read from...'
> will read the name of the decompressed temporary file, not the source.
> It makes more sense to see it as "reading defaults from /proc/config.gz
> since that's obvious to anyone with kernel experience.
>
no, this would only be the behavior of the way you did it.

 - Arnaud

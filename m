Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750852Ab0FNEU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 00:20:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65201 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0FNEU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 00:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=frWvtjxN7wCJSlPlWzQHA4Mo5ON8zMZgui2TWjtGHk2nGQKouqB2AaQkt/IBZ7rRMB
         jJGKYkXOW1BBkcsohtP3bLO+AouSBhDb+kw4NtY8HiEYL3ixz3DkON0ec+5qDRriLkHY
         qMluV8VBjWVxl/t4LpSGWpQh67vWUFKs+0gfs=
MIME-Version: 1.0
In-Reply-To: <YPGdyfWGvNK.A.2FB.W8OFMB@chimera>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.2FB.W8OFMB@chimera>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 14 Jun 2010 12:20:35 +0800
Message-ID: <AANLkTilOhHVi6u0jmPj87s9PGvxPjiT_dxAmqDJ5qTUf@mail.gmail.com>
Subject: Re: [Bug #15712] [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer 
	boots
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael and Pavel,

I can boot successfully on my akita/corgi with my 2.6.35-rc3 kernel.
I'll find some time to test v2.6.34 though.

Pavel,

Is any more update on your side?

On Sun, Jun 13, 2010 at 10:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15712
> Subject         : [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Date            : 2010-04-01 6:06 (74 days old)
> Message-ID      : <20100401060624.GA1329@ucw.cz>
> References      : http://marc.info/?l=linux-kernel&m=127010200817402&w=2
> Handled-By      : Eric Miao <eric.y.miao@gmail.com>
>
>
>

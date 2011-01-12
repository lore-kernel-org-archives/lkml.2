Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1ALRNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:13:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37747 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1ALRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=u3MUJo11JNa0O+KGRHoTtn6lQhfUfqzN68b8tpnnjhuVsMwndfmHkzZQ8PlGsIYp2m
         S1sZTOeM/dCDGqL30aFDq5YI6Jb41Pj+QvMEoxwLmJ7h9nZ/3rdeJZ7kaIlDKRYq2ibS
         HUxMR1alpRtBnV2ZdRct0exoEBBmSVSgXaS1c=
MIME-Version: 1.0
In-Reply-To: <20110111224809.GA20839@aftab>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
	<1294700597-24239-1-git-send-email-mikew@google.com>
	<20110111065540.GA16036@aftab>
	<AANLkTimXfUH-PYpdRcLR4+QkG7uOzYzSC6VZ6HnkB9jE@mail.gmail.com>
	<20110111204909.GE17619@aftab>
	<AANLkTimQNnxnoFPWjh6cHp_x9ZayDdcXdV+qbee8XK_r@mail.gmail.com>
	<20110111224809.GA20839@aftab>
Date: Wed, 12 Jan 2011 09:12:56 -0800
X-Google-Sender-Auth: ULfOWQ-_QPRQZwjum--atVrlsVU
Message-ID: <AANLkTinSzLzTK+39hemOuPfWhCXmnY2jj_E8XDNo7ouH@mail.gmail.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Mike Waychison <mikew@google.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Duncan Laurie <dlaurie@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 2:48 PM, Borislav Petkov <bp@amd64.org> wrote:
> True, although not always reliable due to that context corruption. Tony
> Luck is adding code for writing the error information to a persistent
> storage _before_ you reset so on platforms with such a device you'll
> be able to look at MC4 (or any of the MCE regs, for that matter) after
> reset, which, I think, would make error analysis much more convenient.
> See http://marc.info/?l=linux-arch&m=129356804427008&w=2.

This code is also in linux-next (any next-2011* tag).  I'd be very happy
to get some testing reports, feedback on the code, etc.

-Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0KBHf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:35:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38020 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0KBHfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Udijde7qizjWnYVmtC6+9/DiZrgK4L42c7OQ6Gda3jsibqxX9TqiHPcghR6GYTuqwU
         eidOGPswYHaJfGLQe4BpigtKFZNx2p6jQBewjv8oN7NW3plZjVj/W7O4x4ia8Gq2bnvU
         WSX7vofYyRYCit2AZ4FzzdjEx78s/H8OxJItc=
MIME-Version: 1.0
In-Reply-To: <20101029122534.d4d6a439.akpm@linux-foundation.org>
References: <1288364066-18709-1-git-send-email-michael.hennerich@analog.com> <20101029122534.d4d6a439.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 2 Nov 2010 03:35:30 -0400
Message-ID: <AANLkTikq_D_HjMG0kSqTNc4aoFhtN71usVcNGGz2pAn4@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] video: backlight: adp8870: Fix
 warn_unused_result warning reported by Stephen Rothwell
To: Andrew Morton <akpm@linux-foundation.org>
Cc: michael.hennerich@analog.com, drivers@analog.com, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        rpurdie@linux.intel.com, device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 15:25, Andrew Morton wrote:
>> Subject: [PATCH] video: backlight: adp8870: Fix warn_unused_result warning reported by Stephen Rothwell
>
> Lots of people are doing this "video: backlight: adp8870:" thing
> lately.  And it's good, but why not just use
> "drivers/video/backlight/adp8860_bl.c" to identify the affected
> susbsytem/file/etc?  It's simple and uniform.  It's not always the
> appropriate thing to do, but replacing the /'s with ": " seems rather
> random and pointless.

the colons and spaces make it a lot easier to pick out in a git log.
your suggestion makes it much harder to read due to the lack of
whitespace.
-mike

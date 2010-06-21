Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0FUF6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:58:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34535 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0FUF6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QtmK6pzK9eI5bgUrUVDTlLTKgt/5YVckbTB2iafXcwICEdi8rjaFM7P6NHIOoAeCLu
         0nlvfcjku//owgY3DFGYZaMawdDUbkAAVsyob4g832LquDZtykagepxLFtXVIppl5aPW
         Io0R2+SYKZMadb7PwnANS6S0YIuSmRG6KXjZk=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #16231] Noticeable slow-down in 2.6.35-rc3
Date: Mon, 21 Jun 2010 06:58:08 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "John Fastabend" <john.r.fastabend@intel.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.xkE.aMpHMB@chimera>
In-Reply-To: <W8JfMs9cZw.A.xkE.aMpHMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006210658.08740.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 June 2010, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the
> tracking team know (either way).
>

As noted below, the problem is fixed by John's patch. I added a Tested-by to the 
bugzilla report a few days ago. I guess it should stay open, however, until 
Linus has applied the patch to mainline.

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16231
> Subject		: Noticeable slow-down in 2.6.35-rc3
> Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2010-06-13 20:15 (8 days old)
> First-Bad-Commit:
> http://git.kernel.org/linus/597a264b1a9c7e36d1728f677c66c5c1f7e3b837
> Message-ID	: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127646015226601&w=2
> Handled-By	: John Fastabend <john.r.fastabend@intel.com>
> Patch		: https://patchwork.kernel.org/patch/105859/



-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller

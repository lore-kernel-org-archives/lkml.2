Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0G1RLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:11:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62444 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0G1RLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gpfZJMZufK/4cDLKX8xS/4cS+lSam9HHWGUHauhIFUL7qR2oH8TXQ2qYaJO1hspx9Q
         tyQYY7V2/gUrFtSf0FEK+pN3YwzGXRj2Z2YnlCdQ9b5ASImy/B0WqxH9KWDtNhfBLq/V
         NFHoa41Z5OGergetSrBoOs0UysshZJ8NISzWU=
MIME-Version: 1.0
In-Reply-To: <B852767254C5C94EBB1040EE0EFA060094B73B31@dlee01.ent.ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
	<1280328052-31292-2-git-send-email-ernesto@ti.com>
	<1280328052-31292-3-git-send-email-ernesto@ti.com>
	<4C504719.3020007@ti.com>
	<4C504D66.8090302@ti.com>
	<B852767254C5C94EBB1040EE0EFA060094B73B31@dlee01.ent.ti.com>
Date: Wed, 28 Jul 2010 20:11:44 +0300
Message-ID: <AANLkTi=3K1NC4nGnuTBdVmTOmmG0JEZrG9vKhOvYgXhf@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging:ti dspbridge: remove unnecessary check for 
	NULL pointer in cmm.c
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ramos Falcon, Ernesto" <ernesto@ti.com>
Cc: "Menon, Nishanth" <nm@ti.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ernesto,

On Wed, Jul 28, 2010 at 7:53 PM, Ramos Falcon, Ernesto <ernesto@ti.com> wrote:
>>here is a better approach:
>>remove cmm_xlator_delete altogether

[...]

> I considered this approach before but in terms of maintainability I thought it was easier to locate where translator tables are destroy if we keep cmm_xlator_delete function.

That's not maintainability, that's debugging convenience. AFAIU linux
is all about maintenance, because that provides real, tangible, and
proven gains. Debugging convenience gains are hypothetical; you don't
really know how useful it will be to have a separate free function.

And please avoid bottom-posting, instead use interleaved style,
otherwise people see a comment, and then have to scroll down to see
the answer.
http://en.wikipedia.org/wiki/Posting_style#Interleaved_style

-- 
Felipe Contreras

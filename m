Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1HCTKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:10:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57624 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HCTKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxST2J+LDMB=1ctnw2WGxV+a-cm3FE-1AjwnXMNDkt32g@mail.gmail.com>
References: <alpine.LFD.2.02.1108031137590.22067@x980>
	<CA+55aFxST2J+LDMB=1ctnw2WGxV+a-cm3FE-1AjwnXMNDkt32g@mail.gmail.com>
Date: Wed, 3 Aug 2011 12:10:14 -0700
X-Google-Sender-Auth: ILUxtEcnq0KBLFhjp4UAuuD6S20
Message-ID: <CA+8MBbKavpgkf-ByB5-x9k5NCnW_W9Nkp2pQMXTGvTZEdTYg1w@mail.gmail.com>
Subject: Re: [GIT PATCH] APEI patches for Linux 3.1
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 9:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  fatal: Couldn't find remote ref apei-release
>
> Forgot yo push?

Looks like he pushed to the wrong tree. There is a 3 hour old
apei-release branch here:

 git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git
apei-release

-Tony

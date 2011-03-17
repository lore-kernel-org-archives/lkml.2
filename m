Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1CQNUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:20:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1CQNUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xmiNkobgwxziONyBSEZNMnlqRNObSfxnbkLvJUlhM9gc0C/3XQkDfaKshjg80aOidW
         FEhCpYUccHM6jjWLlFfVfvD5HN//ChVmLSqQl6vSx26Rx1/8ofK8p/N/ZDVDk/v/jh/y
         V1T4tzTkYUZE8xpuszRdDxRxE5/iA4pZlPl2s=
MIME-Version: 1.0
In-Reply-To: <20110317131508.GB30807@sepie.suse.cz>
References: <cover.1295006561.git.mfm@muteddisk.com>
	<20110317131508.GB30807@sepie.suse.cz>
Date: Thu, 17 Mar 2011 14:19:59 +0100
X-Google-Sender-Auth: 0W8JA0OPcdu-DwQVaLAJlVrg0tg
Message-ID: <AANLkTikiBgigwOkXbYpTqr-4ihVYrmYB49pvh7k2toLz@mail.gmail.com>
Subject: Re: [RESEND PATCH 00/27] update makefiles to use the newer flag variables
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: matt mooney <mfm@muteddisk.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 14:15, Michal Marek <mmarek@suse.cz> wrote:
> On Fri, Jan 14, 2011 at 06:12:23AM -0800, matt mooney wrote:
>> These are the patches that never made their way into the linux-next tree.
>> I have added all of the acks that came through.

>>   m68k: change to new flag variables

> I committed these to kbuild.2.6.git#trivial and will send a pull request
> to Linus.

JFYI, the m68k one went in last night through the m68k tree.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

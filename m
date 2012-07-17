Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2GQFFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:05:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53353 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2GQFFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120716184611.GA16422@redhat.com>
References: <CAHdPZaM8Vnfkkon_vCF-jPQLq6WH482ozhH3U08hF30bOMr7Ow@mail.gmail.com>
	<CAFLxGvzkx6e19Gj=vKj3yjW3Yjj3eBx1SbGkmdbTMK6WMtX5Bg@mail.gmail.com>
	<CAHdPZaM3Xq9=HLJztQe2hW7mxwatYeeUV7AKnCEr0xzpTJwQRg@mail.gmail.com>
	<20120716184611.GA16422@redhat.com>
Date: Tue, 17 Jul 2012 10:35:31 +0530
Message-ID: <CAHdPZaNDFjgtVe+VY_qx=o4Xo+LUuoTry6MtFO2i5U8YGiyp0g@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000010 on 3.5-rc6
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Dave Jones <davej@redhat.com>, "devendra.aaru" <devendra.aaru@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Jul 17, 2012 at 12:16 AM, Dave Jones <davej@redhat.com> wrote:
>
> Check the bugs-found.txt file in trinity.git before reporting bugs found with it.
> This one already got reported.. https://lkml.org/lkml/2012/7/13/328
> I try to keep that file up to date to reduce multiple reports of the same bug.
> (also, for that reason, please cc me on bugs you find with it!)
>
> thanks,
>
>         Dave

Thanks, Sorry for not seeing the bug-list. I will cc you in every bug
reported from trinity.

Devendra

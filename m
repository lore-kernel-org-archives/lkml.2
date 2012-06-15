Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2FOUyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:54:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60037 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab2FOUyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <1339762071.2050.20.camel@foo>
References: <1336004953.4240.9.camel@mop>
	<20120526111143.GA32304@lizard>
	<CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
	<1338307620.886.21.camel@mop>
	<20120615000422.GA8591@kroah.com>
	<1339762071.2050.20.camel@foo>
Date: Fri, 15 Jun 2012 13:54:34 -0700
Message-ID: <CA+8MBb+KO724UkZG=THCVabJcgga-_8_QiPwX61s=UQ5bBi-vA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
From: Tony Luck <tony.luck@gmail.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 5:07 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Thu, 2012-06-14 at 17:04 -0700, Greg KH wrote:
>
>> As no one seems to have responded, care to resend this with a
>> signed-off-by so I can queue it up for 3.6?  If people complain, it can
>> still go to 3.5, but given that no one is saying anything, I guess no
>> one cares...
>
> Sounds like a good plan. Here it is.

This got squeezed out of my TODO list ... sorry.  pstore bits work fine. I'd
like to see this go into 3.5.

Thanks

Tested-by: Tony Luck <tony.luck@intel.com>

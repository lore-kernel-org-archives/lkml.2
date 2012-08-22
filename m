Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab2HVVpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:45:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2HVVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:45:42 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Christopher Heiny <cheiny@synaptics.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [RFC PATCH 1/17] input: RMI4 public header file and documentation.
Date: Wed, 22 Aug 2012 14:45:35 -0700
Message-ID: <1965688.fPKEQJnVvJ@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.8.5 (Linux/3.5.1-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACRpkdbP1uTXC9jVNVG3es0KFRq+8MaUa6=6nPuG5WUz5jgiRQ@mail.gmail.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <1345241877-16200-2-git-send-email-cheiny@synaptics.com> <CACRpkdbP1uTXC9jVNVG3es0KFRq+8MaUa6=6nPuG5WUz5jgiRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 22, 2012 09:08:00 PM Linus Walleij wrote:
> On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
> <cheiny@synaptics.com> wrote:
> 
> > +/* Helper fn to convert a byte array representing a short in the RMI
> > + * endian-ness to a short in the native processor's specific endianness.

Is RMI-endiannes different from BE and LE (joking)? Please simply state what 
on-wire endianness is and use xx_to_cpu() or cpu_to_xx() as needed. I think I 
mentioned it about a year ago already...

Thanks.

-- 
Dmitry

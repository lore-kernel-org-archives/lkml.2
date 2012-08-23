Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2HWA05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:26:57 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:15747 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab2HWA0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:26:54 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 22 Aug 2012 17:00:11 -0700
Message-ID: <503578CC.801@synaptics.com>
Date: Wed, 22 Aug 2012 17:26:52 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
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
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <1345241877-16200-2-git-send-email-cheiny@synaptics.com> <CACRpkdbP1uTXC9jVNVG3es0KFRq+8MaUa6=6nPuG5WUz5jgiRQ@mail.gmail.com> <1965688.fPKEQJnVvJ@dtor-d630.eng.vmware.com>
In-Reply-To: <1965688.fPKEQJnVvJ@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 02:45 PM, Dmitry Torokhov wrote:
> On Wednesday, August 22, 2012 09:08:00 PM Linus Walleij wrote:
>> >On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
>> ><cheiny@synaptics.com>  wrote:
>> >
>>> > >+/* Helper fn to convert a byte array representing a short in the RMI
>>> > >+ * endian-ness to a short in the native processor's specific endianness.
> Is RMI-endiannes different from BE and LE (joking)? Please simply state what
> on-wire endianness is and use xx_to_cpu() or cpu_to_xx() as needed. I think I
> mentioned it about a year ago already...

Gronk. I thought I'd killed that.  But obviously didn't do a thorough job.

[Slinks off in embarrassment.]

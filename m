Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2HCURb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:17:31 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:57395 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2HCUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:17:28 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2012 16:17:27 EDT
Date: Fri, 3 Aug 2012 23:08:22 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: Andi Kleen <andi@firstfloor.org>, gregkh@linuxfoundation.org, kay@vrfy.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
Message-ID: <20120803200822.GC731@harshnoise.musicnaut.iki.fi>
References: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com>
 <m2628z6euk.fsf@firstfloor.org>
 <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 03, 2012 at 11:25:37AM -0700, Pandita, Vikram wrote:
> > And really: Wasting 1/3 of the 80 character line is too much.
> 
> You _WASTE_ 4 chars only if you are interested in this info by
> enabling: CONFIG_PRINTK_CPUID

I guess you waste 4 + 3 chars? You could optimize the length by checking
CONFIG_NR_CPUS?

A.

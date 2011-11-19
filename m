Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1KSLMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:12:01 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:49715 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab1KSLL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:11:59 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "Tabi Timur-B04825" <B04825@freescale.com>
Subject: Re: [PATCH v3.1] [resend] Resurrect Intel740 driver: i740fb
Date: Sat, 19 Nov 2011 12:11:02 +0100
User-Agent: KMail/1.9.10
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201111182154.45139.linux@rainbow-software.org> <CAOZdJXVx88nEAQkL13n1QXVw=kOe03QsD=pffHoZ8gecL7u8dA@mail.gmail.com>
In-Reply-To: <CAOZdJXVx88nEAQkL13n1QXVw=kOe03QsD=pffHoZ8gecL7u8dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111191211.08704.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 November 2011 00:53:27 Tabi Timur-B04825 wrote:
> On Fri, Nov 18, 2011 at 2:54 PM, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > Hello,
> > this is an v3 attempt to resurrect an old (like 2.4.19) out-of-tree
> > driver for Intel740 graphics cards and modify it for recent kernels. The
> > old driver is located at:
> > http://sourceforge.net/projects/i740fbdev/files/
>
> Would you please run checkpatch.pl on the patch and fix the complaints
> it has?  I get this:
>
> total: 45 errors, 67 warnings, 1619 lines checked
>
> This patch has tons of style problems.

The 45 errors are in i740_calc_fifo(), which now looks good and is readable. 
Reformatting according to checkpatch makes it look bad and unredable. This 
was already discussed before.
The warnings are lines over 80 characters, which are common in most fb 
drivers. Splitting them makes code hard to read.

-- 
Ondrej Zary

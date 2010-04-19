Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0DSTtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:49:20 -0400
Received: from imr3.ericy.com ([198.24.6.13]:35994 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0DSTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:49:16 -0400
Subject: Re: [PATCH/RESEND] MIPS: Fix sibyte watchdog initialization
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Wim Van Sebroeck <wim@iguana.be>
CC: alan@lxorguk.ukuu.org.uk, "andy.sharp@onstor.com" <andy.sharp@onstor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>
In-Reply-To: <20100419191956.GK15728@infomag.iguana.be>
References: <1271691431-28166-1-git-send-email-guenter.roeck@ericsson.com>
	 <20100419191956.GK15728@infomag.iguana.be>
Content-Type: text/plain
Organization: Ericsson
Date: Mon, 19 Apr 2010 12:44:51 -0700
Message-ID: <1271706291.7616.79.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 15:19 -0400, Wim Van Sebroeck wrote:
> Hi Guenter,
> 
> > Watchdog configuration register and timer count register were interchanged,
> > causing wrong values to be written into both registers.
> > This caused watchdog triggered resets even if the watchdog was reset in time.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> Just let me know when this can be added as a fix in the watchdog tree.
> 
The earlier the better from my perspective. 

Ralf may have had the mips tree in mind - might make sense to
synchronize with him.

Thanks,
Guenter



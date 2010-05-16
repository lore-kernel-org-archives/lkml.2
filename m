Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0EPWdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:33:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:26167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab0EPWd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,243,1272870000"; 
   d="scan'208";a="518398360"
Date: Mon, 17 May 2010 00:34:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2] mfd: add TC35892 MFD core
Message-ID: <20100516223402.GE3236@sortiz.org>
References: <1272514380-8160-1-git-send-email-rabin.vincent@stericsson.com>
 <20100509220050.GD3269@sortiz.org>
 <20100514104902.GA19869@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514104902.GA19869@bnru02.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Fri, May 14, 2010 at 04:19:03PM +0530, Rabin VINCENT wrote:
> Hi Samuel,
> 
> On Mon, May 10, 2010 at 12:00:51AM +0200, Samuel Ortiz wrote:
> > On Thu, Apr 29, 2010 at 09:42:59AM +0530, Rabin Vincent wrote:
> > > The TC35892 I/O Expander provides 24 GPIOs, a keypad controller, timers,
> > > and a rotator wheel interface.  This patch adds the MFD core.
> > Both this one and the GPIO patch applied, many thanks.
> 
> Thanks.  In your for-next tree, it looks like the Author: information
> for these two patches seems to have been lost.  Perhaps this could be
> fixed up?  Thanks again.
Sorry, I had to apply those patches manually and forgot to change the author
field when committing. Should be fixed now.

Cheers,
Samuel.


> Rabin

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1LaQ1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 11:27:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36467 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1LaQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 11:27:32 -0500
Date: Sat, 31 Dec 2011 16:27:18 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20111231162718.GA27867@srcf.ucam.org>
References: <20111231004015.GA23226@srcf.ucam.org>
 <Pine.LNX.4.44L0.1112311028270.22327-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112311028270.22327-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 31, 2011 at 10:33:12AM -0500, Alan Stern wrote:

> Nothing has changed in the USB layer -- it has always been true that
> devices could be reset during a suspend/resume cycle.  This isn't a
> matter of how the stack is written or anything like that; some
> motherboards simply do not provide suspend power to their USB
> controllers.  Or the firmware reinitializes the controllers and
> attached devices during resume, forcing Linux's USB core to reset
> every device on the affected buses.

I know that this is hardware dependent, but the hardware hasn't changed 
here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

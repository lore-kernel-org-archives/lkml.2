Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0IOCz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 22:55:56 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:50828 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0IOCzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 22:55:53 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2010 22:55:53 EDT
Date: Tue, 14 Sep 2010 20:48:40 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Simon Arlott <simon@fire.lp0.eu>, Jordan Crouse <jcrouse@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: GA-MA69VM-S2 requires pci=nocrs with 2.6.35.4
Message-ID: <20100915024840.GA28781@helgaas.com>
References: <de55082de958760245f23930b79ab42b7c54c838@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
 <201009131716.18197.bjorn.helgaas@hp.com>
 <f041c95ed553edce2bb319fd31a9dc5402863437@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
 <201009140817.18988.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009140817.18988.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 08:17:16AM -0600, Bjorn Helgaas wrote:
> On Tuesday, September 14, 2010 05:38:49 am Simon Arlott wrote:
> > On Tue, September 14, 2010 00:16, Bjorn Helgaas wrote:

> > > I can see from the stalled.txt log that we did call sb600_disable_hpet_bar(),
> > > and it *looks* like that should have disabled BAR 1.  But apparently it
> > > didn't.  Would you mind collecting another log with the patch below?
> > 
> > Whenever I next need to reboot, I can try the patch, but that won't be soon...
> 
> OK.  Just let me know if/when you have any more information.  I opened
> this bugzilla for this problem:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=18482

I attached an updated patch to this bugzilla, so please give it
a try when it's convenient for you.

Bjorn

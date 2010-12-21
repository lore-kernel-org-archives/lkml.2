Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab0LUImJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:42:09 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:41369 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0LUImH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bm+xxfNOorNgYMq9QXprA/Q38oHOB7WVT7dB59sA3GbyPKp6ps77o7tuJYtw3DkiFl
         ZMQhSpw/S6bl0uLHZJVKQbl0LBoyw7XAfgWYP7+3MJBzUh87OAOasluar2LW1Y82BDNc
         l2fD2duRPf7JAhMkMuvKOvhviAkBatvstiu+Y=
Date: Tue, 21 Dec 2010 11:42:00 +0300
From: Kulikov Vasiliy <segooon@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Stephen Kitt <steve@sk2.org>,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug #24392] AGP aperture disabled, worked in 2.6.35
Message-ID: <20101221084200.GA2537@albatros>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
 <xqq2Z3iR9HJ.A.cHG.-0fDNB@chimera>
 <201012201214.57068.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012201214.57068.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 20, 2010 at 12:14 -0700, Bjorn Helgaas wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24392
> > First-Bad-Commit: http://git.kernel.org/linus/96576a9e1a0cdb8a43d3af5846be0948f52b4460
...
> That's kind of ugly because it's an exception to the normal "call
> pci_enable_device() first" rule, and it leads to bogus "conflicts"
> like this:

I don't understand rationale, but if standard enable-before-use breaks
the boot then explicit comment _why_ do it is necessary here.


Thanks,

-- 
Vasiliy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2IDQNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:13:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41539 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IDQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:12:58 -0400
Date: Tue, 4 Sep 2012 17:12:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] First attempt at kernel secure boot support
Message-ID: <20120904161256.GA22961@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <20120904170853.0fa6b27b@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904170853.0fa6b27b@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 05:08:53PM +0100, Alan Cox wrote:
> On Tue,  4 Sep 2012 11:55:06 -0400
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > The UEFI Secure Boot trust model is based on it not being possible for a
> > user to cause a signed OS to boot an unsigned OS
> 
> Unfortunately you can't fix this at kernel level because an untrusted
> application can at GUI level fake a system crash, reboot cycle and phish
> any basic credentials such as passwords for the windows partition.

Any well-designed software asking for credentials should already be 
requiring a SAK, so in that case we just need to implement sensible SAK 
support in Linux.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

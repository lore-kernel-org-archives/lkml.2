Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2IDQNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:13:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41560 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab2IDQNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:13:45 -0400
Date: Tue, 4 Sep 2012 17:13:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 05/11] asus-wmi: Restrict debugfs interface
Message-ID: <20120904161343.GB22961@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-6-git-send-email-mjg@redhat.com>
 <20120904171205.3dfbcabd@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904171205.3dfbcabd@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 05:12:05PM +0100, Alan Cox wrote:
> On Tue,  4 Sep 2012 11:55:11 -0400
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > We have no way of validating what all of the Asus WMI methods do on a
> > given machine, and there's a risk that some will allow hardware state to
> > be manipulated in such a way that arbitrary code can be executed in the
> > kernel. Add a capability check to prevent that.
> 
> This is true of any firmware method on any device Why pick on ASUS. Have
> you run this through ASUS and discussed it with them. It seems highly
> inappropriate to cripple a specific vendors feature set without
> discussion and an Ack from the vendor concerned.

Because asus-wmi is the only driver that has a debugfs interface that 
lets you run arbitrary WMI methods.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

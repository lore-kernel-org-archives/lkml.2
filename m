Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1HXNmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:42:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44890 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1HXNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:42:48 -0400
Date: Wed, 24 Aug 2011 14:42:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND][PATCH 0/5] Support for the TS-5500 board
Message-ID: <20110824134241.GA12982@srcf.ucam.org>
References: <1311887450-22235-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110809233208.1a71122e@lenov0n>
 <4E421CD8.3090606@canonical.com>
 <CAHR064hamS0gHqQR5a5UAanN89CzzW94sjW6SB3=8MAcf6pkMg@mail.gmail.com>
 <20110810100629.715c3bb7@v0nbox>
 <1312986047.2989.47.camel@i7.infradead.org>
 <20110810150919.39519e62@v0nbox>
 <20110812102627.1281eb11@v0nbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812102627.1281eb11@v0nbox>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:26:27AM -0400, Vivien Didelot wrote:
> On Wed, 10 Aug 2011 15:09:19 -0400,
> Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> > I'm a bit confused with what should be done for the support for an
> > embedded platform (X86-based) like this TS-5500. Is the actual code
> > hierarchy OK? What is the impact of adding a device-tree to this code?
> > 
> > Thanks,
> > Vivien.
> 
> Can I get the maintainer's view on this?

You'd probably want to Cc: the x86 architecture maintainers - you've 
only got the one for x86-specific drivers that don't fall into other 
categories at the moment.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

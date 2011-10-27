Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1J0Vxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:53:42 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:20388 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1J0Vxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:53:41 -0400
Date: Thu, 27 Oct 2011 23:53:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Remove quotes of maintaners's names
Message-ID: <20111027215339.GA3653@merkur.ravnborg.org>
References: <1319739381-5244-1-git-send-email-marcos.mage@gmail.com> <610B86C6-622E-4EFE-89DF-BF09BDB4D765@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <610B86C6-622E-4EFE-89DF-BF09BDB4D765@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 02:35:54PM -0700, Kirsher, Jeffrey T wrote:
> On Oct 27, 2011, at 14:14, "Marcos Paulo de Souza" <marcos.mage@gmail.com> wrote:
> 
> > Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> > ---
> > MAINTAINERS |  128 +++++++++++++++++++++++++++++-----------------------------
> > 1 files changed, 64 insertions(+), 64 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 27af9c9..0bea8d7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -140,7 +140,7 @@ S:  Supported
> > F:     drivers/scsi/3w-*
> >
> > 53C700 AND 53C700-66 SCSI DRIVER
> > -M:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > +M:     James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> > L:     linux-scsi@vger.kernel.org
> > S:     Maintained
> > F:     drivers/scsi/53c700*
> > @@ -422,7 +422,7 @@ F:  drivers/char/agp/
> > F:     include/linux/agp*
> >
> 
> Adding lkml and netdev mailing lists...
> 
> The reason these names are in quotes is because they need to be wrapped in quotes when used in a git patch (I.e. CC: "David S. Miller" <davem@davemloft.net>) because of the . in the friendly name.

And anyone that copy'n'paste the name to their mail client would also by screwed if
the quotes are missing.

	Sam

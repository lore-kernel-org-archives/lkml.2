Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0DVNBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:01:16 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:48514 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0DVNBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V/dp0l4IUR5CawUcpND/qX+33/Bmc+/AY8s7wiRGq5vPH1ZQi/+SY2qyGlW97G//Jq
         kK9/7A6fxJT/6F2KeKdKtPthH1T6T20FGw0CKvliATW4dgM2yO42kvAIlErap2djrgrK
         t1DTVXceqxx4vfrv02SC32W1T3itKumlcurPg=
MIME-Version: 1.0
In-Reply-To: <20100421180552.GB24842@suse.de>
References: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
	 <20100421180552.GB24842@suse.de>
Date: Thu, 22 Apr 2010 15:01:12 +0200
Message-ID: <h2tfb5cec441004220601q4d885bc1nee96c43016042009@mail.gmail.com>
Subject: Re: [PATCH 1/2] Composite framework: Add suspended sysfs entry
From: Chouteau Fabien <fabien.chouteau@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 8:05 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Wed, Apr 21, 2010 at 05:38:21PM +0200, fabien.chouteau@gmail.com wrote:
> > From: Fabien Chouteau <fabien.chouteau@barco.com>
> >
> >
> > Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
> > ---
> >  drivers/usb/gadget/composite.c |   21 +++++++++++++++++++++
> >  include/linux/usb/composite.h  |    1 +
> >  include/linux/usb/gadget.h     |    4 ++++
> >  3 files changed, 26 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> > index 09289bb..a5352f3 100644
> > --- a/drivers/usb/gadget/composite.c
> > +++ b/drivers/usb/gadget/composite.c
> > @@ -898,6 +898,18 @@ static void composite_disconnect(struct usb_gadget *gadget)
> >
> >  /*-------------------------------------------------------------------------*/
> >
> > +static ssize_t composite_show_suspended(struct device *dev,
> > +                                     struct device_attribute *attr,
> > +                                     char *buf)
>
> As you added a sysfs file, it is required that you also add an entry in
> Documentation/ABI/ that describes the file and what it is for.  Please
> respin this with that added to the patch.

ok,
is  "testing/sysfs-devices-platform-_UDC_-gadget" a good choice for
the file name?
("_UDC_" depends on the UDC driver name)

--
Fabien Chouteau
EPITA GISTR 2010

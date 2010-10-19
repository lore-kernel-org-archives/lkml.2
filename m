Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0JSUyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:54:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55446 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab0JSUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:54:11 -0400
Date: Tue, 19 Oct 2010 18:54:03 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Bluetooth: btwilink driver
Message-ID: <20101019205403.GA2331@vigoh>
References: <1287521858-15190-1-git-send-email-pavan_savoy@ti.com>
 <20101019203913.GA2322@vigoh>
 <19F8576C6E063C45BE387C64729E739404AA4E790D@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA4E790D@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Savoy, Pavan <pavan_savoy@ti.com> [2010-10-20 02:15:29 +0530]:

> 
> 
> 
> > -----Original Message-----
> > From: Gustavo F. Padovan [mailto:pao@profusion.mobi] On Behalf Of Gustavo F.
> > Padovan
> > Sent: Tuesday, October 19, 2010 3:39 PM
> > To: Savoy, Pavan
> > Cc: marcel@holtmann.org; linux-bluetooth@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH v3] Bluetooth: btwilink driver
> > 
> > * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-10-19 16:57:38 -0400]:
> > 
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > >
> > > v3 comments
> > >
> > > Marcel, Gustavo, & list,
> > > Please review this version of patch.
> > >
> > > Anderson,
> > > I have taken care of most of the comments you had.
> > > Have re-wrote some of the code commenting you've mentioned.
> > > Thanks for the comments,
> > >
> > > The other few like -EPERM for platform driver registration is to keep
> > > it similar to other drivers
> > 
> > Which drivers returns -EPERM to any kind of error? The are many reasons
> > why the funcion can fail, and you want to give the best error report to the
> > user. Use EPERM to all of them is just wrong.
> 
> Yes, it can fail for plenty of reasons.
> So I'll just return whatever I get from platform_driver_register.
> Is this OK?

Yes. 
 
> 
> > >type casting is maintained just to feel safe
> > > and have style similar to other drivers.
> > 
> > We don't need to feel safe here. Type cast actually can hide errors,
> > only use them when you really need to cast, in many case here you don't.
> 
> Ok, I can remove type casting.
> I am not really for or against it...

Yes, do that please. ;)


-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi

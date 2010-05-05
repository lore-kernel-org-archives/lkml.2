Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab0EEJSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:18:12 -0400
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:48005 "EHLO
	relay2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178Ab0EEJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:18:10 -0400
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.8.179.104
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100504180247.GC29428@core.coreip.homeip.net>
References: <1272994594.13354.215.camel@localhost.localdomain>
	 <20100504180247.GC29428@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 05 May 2010 10:18:04 +0100
Message-ID: <1273051084.13354.290.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 (2.30.0-3.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 11:02 -0700, Dmitry Torokhov wrote:
> On Tue, May 04, 2010 at 06:36:34PM +0100, Bastien Nocera wrote:
> > As those computers never had any i8042 controllers, and the
> > current lookup code could potentially lock up/hang/wait for
> > timeout for long periods of time.
> > 
> > Fixes intermittent hangs on boot on a MacbookAir1,1
> > 
> > Signed-off-by: Bastien Nocera <hadess@hadess.net>
> > ---
> >  drivers/input/serio/i8042.c |   18 ++++++++++++++++++
> >  1 files changed, 18 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> > index d84a36e..2be7207 100644
> > --- a/drivers/input/serio/i8042.c
> > +++ b/drivers/input/serio/i8042.c
> 
> This should go into i8042-x86ia64io.h and used to create PNP whitelist.

Sorry, I don't understand what needs to be done here.


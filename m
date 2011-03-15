Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1COIgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:36:39 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40338 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab1COIgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:36:36 -0400
Date: Tue, 15 Mar 2011 09:36:32 +0100
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Florian Mickler <florian@mickler.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Oliver Neukum <oliver@neukum.org>, Jack Stone <jwjstone@fastmail.fm>
Subject: Re: [PATCH 1/2 v3] [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110315093632.5fc9fb77@schatten.dmk.lab>
In-Reply-To: <20110306185713.5b621e80@schatten.dmk.lab>
References: <201103061744.15946.oliver@neukum.org>
	<1299433677-8269-1-git-send-email-florian@mickler.org>
	<20110306185713.5b621e80@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011 18:57:13 +0100
Florian Mickler <florian@mickler.org> wrote:

> On Sun,  6 Mar 2011 18:47:56 +0100
> Florian Mickler <florian@mickler.org> wrote:
> 
> 
> > +static void dib0700_disconnect(struct usb_interface *intf) {
> 
> 
> That { should go on its own line... sorry ;-)
> 
> If that patch is acceptable, I can resend with that fixed. 
> 
> Regards,
> Flo


Hi Mauro, 

what about this patch? I have similar patches for the same problem in
the other dvb-usb drivers in need of beeing fixed. Are you
maintaining these drivers or should I find someone else to pick these
up? 

Regards,
Flo

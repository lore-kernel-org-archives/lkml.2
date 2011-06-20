Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1FTOyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:54:09 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:60651 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1FTOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:54:06 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.131
X-Originating-IP: 94.192.232.89
Subject: Re: Reporting screen/laptop orientation data to userspace
From: Bastien Nocera <hadess@hadess.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alberto Mardegan <mardy@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, "Javier S. Pedro" <maemo@javispedro.com>,
        linux-input@vger.kernel.org
Date: Mon, 20 Jun 2011 15:53:58 +0100
In-Reply-To: <20110606194122.0fb8d46c@lxorguk.ukuu.org.uk>
References: <4DE1FA7F.3050308@users.sourceforge.net>
	 <1307116529.2669.130.camel@novo.hadess.net>
	 <4DEC796E.1050307@users.sourceforge.net>
	 <1307382639.2669.147.camel@novo.hadess.net>
	 <20110606194122.0fb8d46c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308581640.6042.43.camel@novo.hadess.net>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 19:41 +0100, Alan Cox wrote:
> > When an "change" event is received on an accelerometer,
> > open its device node, and from the value, as well as the previous
> > value of the property, calculate the device's new orientation,
> > and export it as ID_INPUT_ACCELEROMETER_ORIENTATION.
> >     
> > Possible values are:
> > * undefined
> > * normal
> > * bottom-up
> > * left-up
> > * right-up
> 
> For quite a few of the discrete accelerometers not being used in
> 'joystick' mode this would make quite a sensible input interface,
> at least for those that generate inputs for their transitions.
> 
> You need a couple more values though because some devices care if they
> are held up/down/left/right or if they are lying flat on their front or
> on their back.
> 
> Phones for example sometimes go to speakerphone if laid flat on their
> back, and go into silent mode if turned over.

I'm not designing for phones though, and it seems to me this should be a
separate attribute anyway (and so did the people who wrote sensorfw for
MeeGo Handset).


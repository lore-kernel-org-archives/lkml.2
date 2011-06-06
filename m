Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1FFSjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:39:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40803 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104Ab1FFSjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:39:48 -0400
Date: Mon, 6 Jun 2011 19:41:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bastien Nocera <hadess@hadess.net>
Cc: Alberto Mardegan <mardy@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, "Javier S. Pedro" <maemo@javispedro.com>,
        linux-input@vger.kernel.org
Subject: Re: Reporting screen/laptop orientation data to userspace
Message-ID: <20110606194122.0fb8d46c@lxorguk.ukuu.org.uk>
In-Reply-To: <1307382639.2669.147.camel@novo.hadess.net>
References: <4DE1FA7F.3050308@users.sourceforge.net>
	<1307116529.2669.130.camel@novo.hadess.net>
	<4DEC796E.1050307@users.sourceforge.net>
	<1307382639.2669.147.camel@novo.hadess.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When an "change" event is received on an accelerometer,
> open its device node, and from the value, as well as the previous
> value of the property, calculate the device's new orientation,
> and export it as ID_INPUT_ACCELEROMETER_ORIENTATION.
>     
> Possible values are:
> * undefined
> * normal
> * bottom-up
> * left-up
> * right-up

For quite a few of the discrete accelerometers not being used in
'joystick' mode this would make quite a sensible input interface,
at least for those that generate inputs for their transitions.

You need a couple more values though because some devices care if they
are held up/down/left/right or if they are lying flat on their front or
on their back.

Phones for example sometimes go to speakerphone if laid flat on their
back, and go into silent mode if turned over.

Alan

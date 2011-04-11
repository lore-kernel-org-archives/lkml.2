Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1DKSaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:30:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57642 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1DKSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Gtnspbklj4TS82h5PktH0uA0wlkmeMEYCHgt3deU9Pahog299vVf8mFMTV3SMPx+Sh
         +f/0ZOfYuZTShAoQOkyLVIE4UODZbAU0YzeR1n/7cbJ1amQm4vWmVNZaLrjTlK8AoMr0
         twYYh0HsDQ6HRmQEco0I9607jHPVZinrtE1EE=
Message-ID: <4DA348B3.2010708@gmail.com>
Date: Mon, 11 Apr 2011 20:30:11 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        users@rt2x00.serialmonkey.com, ben@decadent.org.uk
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>	<4DA33F3A.6090707@gmail.com> <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com>
In-Reply-To: <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 07:57 PM, Ivo Van Doorn wrote:

>> links to rt3070.bin rt3071.bin rt3090.bin ???
>
> What do you mean? Those files should be deleted from the linux-firmware
> package. There is no need to keep them around, as with the removal of
> the staging drivers, the last users of those files are gone.

I've changed my mind. I would like to kill them, but people running old
kernels with staging drivers still needs them.

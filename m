Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab1DMP7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:59:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56384 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab1DMP7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sEXptAY7YAhBvo9SP6EFU0RwoT0LQd36KXE/rudAuDy+B6MeMz9dV0bMnxYjYydCGa
         pAkUxNRFegGnEDGcBXXUZqxjqOsBI6og8OOoetFjhyVmUBhW49MpGFjDam4NF4ONZwVC
         /3Ykw3QOXf4Awohs8KN7sfapXdM1Q5NeEju0c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
Date: Wed, 13 Apr 2011 17:59:07 +0200
Message-ID: <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I recall using this driver in staging and it crashing my machine, now thats
> its no longer in staging, I thought I'd give it another try..  Using the

The rt2800usb was not in staging but has been inside the main kernel
tree for quite
some time already, the alternative rt2870sta was in staging and will
be removed very soon.

> following wireless usb adapter, I'm seeing very high latency when using
> the device in Linux, (with Windows, there are no problems).  Using Debian
> Testing + wpa_supplicant, using the following USB adapter:

Can you try disabling powersaving?
iwconfig wlan0 power off

Ivo

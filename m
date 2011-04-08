Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab1DHCSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 22:18:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab1DHCSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 22:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=HRQt7TNRhBCp4yQy5h9LiP+uOdtd8S71NA2xbl5TWGTsIhzS0wSE+ro+bX9lsSuU67
         oT3VP0EHM0sh9DNwEtRh3ouakXu53+SbdHXw1HAY79un/HQ4YvXIGQnHrzWdToC0qBcS
         pZRIId3+krnxkfC1MmVYtYUsKTRRACtt9F30g=
MIME-Version: 1.0
In-Reply-To: <20110407163948.GD31060@kroah.com>
References: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com> <20110407163948.GD31060@kroah.com>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Fri, 8 Apr 2011 04:18:12 +0200
Message-ID: <BANLkTikUrdte93L=3Nq3TXYMpeqRJfj2YQ@mail.gmail.com>
Subject: Re: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This does work on the -rc1 kernel and is 100% reproducible here (same
>> USB port, rebooting the phone between tries).
>
> Any chance you can run 'git bisect' to narrow down the problem to the
> offending change?

Unfortunately I only have this x120e netbook-type machine available
for testing and building at the moment, so it would probably take me a
long time.

Gottfried

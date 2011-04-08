Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1DHNBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:01:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59640 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab1DHNBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ck995JYRAcLJkrw8+dGGkO2g1/5HreF8oEWjIYwnp67D9QAqMAG50eYnnTgZR6tv9q
         szUjN1cwlbgvhoex684T4X+BwBeTWhmPGnlUpJk0zxsCjNFRjQf+2mErDvLhdb14n7mM
         k9Fj+32k4Ye4sPQyRtbRWwWrA9/HbeueKUr8Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTik5VGziYQLQTzMDhYD7CA0QpSNK6g@mail.gmail.com>
References: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
 <20110407163948.GD31060@kroah.com> <BANLkTikUrdte93L=3Nq3TXYMpeqRJfj2YQ@mail.gmail.com>
 <BANLkTik5VGziYQLQTzMDhYD7CA0QpSNK6g@mail.gmail.com>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Fri, 8 Apr 2011 15:01:10 +0200
Message-ID: <BANLkTinYxtZzGOQ708BBAU5CX64S0V017g@mail.gmail.com>
Subject: Re: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
To: huajun li <huajun.li.lee@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-net@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
>   I found the new added mask code 'FLAG_POINTTOPOINT' overlapped
> 'FLAG_MULTI_PACKET' in    include/linux/usb/usbnet.h, this maybe
> caused logic issue in rx_process(). I create a patch for this, but
> have no such a device to test it, could you have a try? thanks.

That patch fixes it, thanks!

Gottfried

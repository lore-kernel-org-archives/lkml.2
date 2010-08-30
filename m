Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0H3DUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:20:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43111 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0H3DUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nj5ypvuBKA7s5JU+azyMpHSZCF6PEmoxcASIzOG8qpvS77DoriEsZO+Y468tEUV/gz
         6/37ghLSxc+jd7960WQjvY2thyulYAZCaj0NeMeXEZpeIuMtjN+FBfVl+9umX4bwNwSU
         AhRnMBnMejHONOHgBg2GQRTK1uut802ZfsDI0=
Message-ID: <4C7B2379.7040705@lwfinger.net>
Date: Sun, 29 Aug 2010 22:20:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: New staging driver for Realtek RTL8192 USB device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Realtek has finally given me permission to submit the driver named r8712u for
the RTL8192 USB device.

My first question is how do you want to get the info. I have it in a git tree at
kernel.org if you want to pull from there, otherwise, I can generate a single
massive patch, or a set of smaller patches. Please advise me.

A second question will be how to handle the driver for this device that is now
in drivers/staging/rtl8192su/. My suggestion would be to remove it, but I'll
leave that to you.

Larry

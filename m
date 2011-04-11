Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1DKRxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:53:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39984 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1DKRxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:53:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=JunvsTKHUJ7IjaTcjswL3luyInX8LgaVmCwhmetGv3uYj0S3Cy9XJC4mreoEWOgUHn
         4QniWrtZ2QYSM3gsLc+y0v4Iq5iHspTvqQyGJUFTyMYD0OthLng9Z47RWnw/f6B2GAEd
         K5eMJ0gCVrGtJ/vpeuAwY7cW4zvmlVYZc4daU=
Message-ID: <4DA33FFD.5070004@gmail.com>
Date: Mon, 11 Apr 2011 19:53:01 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: dwmw2@infradead.org, Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, gwingerde@gmail.com, ben@decadent.org.uk,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Shiang Tu <shiang_tu@ralinktech.com>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
References: <779506.13049.qm@web161604.mail.bf1.yahoo.com>
In-Reply-To: <779506.13049.qm@web161604.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 05:18 PM, Walter Goldens wrote:

> Are there any changelogs for these firmware files? Do they
 > only offer support for newer chips, or are there any actual
 > improvements and bug fixes implemented? Users should know
 > whether updating the firmware will be of any use to them.

Shiang Tu from ralink says [1] :
"We always suggest to use latest firmware, because it's backward
compatible and also has some enhancement, bug fix, or support of new
chip.

For rt5390 or newer chips, it shall upgrade the firmware to this
version, or it may malfunction."

[1] 
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003380.html


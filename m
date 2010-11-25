Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0KYJdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:33:16 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33874 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0KYJdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=thoECHVTGbr/wrEegTnRnpy4JJSGMsr//Pn7sL/xxnUuLvMfmBNOL2Lgnac6EJk7Pg
         S+HarVTEPjks66ZtyLr7/JTLj+bsPNFlzIDlMsI0B/5k2cyb3CqJEAjorCPl2me3866R
         X7iRUHSX+V9BJVkPAxrx6gMmzVn6z9khEOSxc=
Date: Thu, 25 Nov 2010 12:33:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: chris@chris-wilson.co.uk
Cc: mjg@redhat.com, rpurdie@rpsys.net, kernelorg@bof.de,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: back light conflict i915 vs dell-laptop
Message-ID: <20101125093301.GT1522@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	chris@chris-wilson.co.uk, mjg@redhat.com, rpurdie@rpsys.net,
	kernelorg@bof.de, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Schaaf has reported that the i915 driver is setting his
backlight very dim when he starts GDM.

https://bugzilla.kernel.org/show_bug.cgi?id=23472

It should be the dell-laptop platform driver controlling his backlight.

Gnome tries to restore the backlight settings through the dell_laptop
interface in sysfs but it fails.  (Because the platform hardware refuses
to set the settings to what it thinks they already are).

regards,
dan carpenter


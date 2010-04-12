Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0DLTpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:45:20 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:42764 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0DLTpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:45:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH v6 7/8, needs improvement] hid: add suspend/resume hooks for hid drivers
Date: Mon, 12 Apr 2010 21:45:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
References: <20100324233707.7243b04d@neptune.home> <alpine.LNX.2.00.1004121342550.8345@pobox.suse.cz> <20100412185607.10c7b3be@neptune.home>
In-Reply-To: <20100412185607.10c7b3be@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004122145.10396.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. April 2010 18:56:07 schrieb Bruno Prémont:
> > Yes, it will wake the device up from auto-suspension. However, that's 
> > usually what you want to happen, is there is anything you need to dispatch 
> > to the device, isn't it?
> 
> I thought of a report to send to device to ask the device to disable some
> power using feature (e.g. turning off or dimming LEDs)

The device should do this on its own. If it is really necessary you
can do this in suspend()

	Regards
		Oliver

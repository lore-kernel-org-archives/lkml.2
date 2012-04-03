Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2DCK4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:56:03 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:49188 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2DCK4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:56:00 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuOsAATWek9V5qnhPGdsb2JhbABFig2sTQOBDxkBAQEBNzSCCgEFJwsBIyMQCANGFCUKGi6HcrshE4s2hDpjBJVihgCNGg
X-IronPort-AV: E=Sophos;i="4.75,362,1330902000"; 
   d="scan'208";a="7051921"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 3 Apr 2012 12:57:31 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/5] hid: Add idtags to modalias
Message-ID: <20120403105731.GB14201@polaris.bitmath.org>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
 <1333436730-13008-5-git-send-email-rydberg@euromail.se>
 <CAN+gG=F0v1NnBd5G_Z77m3Qf8FuSs5Nj2-W97k=GhFdWmZDiKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+gG=F0v1NnBd5G_Z77m3Qf8FuSs5Nj2-W97k=GhFdWmZDiKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       /* Generic MT device */
> > +       { .driver_data = MT_CLS_DEFAULT,
> > +               HID_USB_MT_DEVICE(HID_ANY_ID,
> > +                       HID_ANY_ID) },
> 
> This breaks the mechanism used to detect serial protocol.
> A better solution would be to keep .driver_data = 0 -> this would tell
> us that the device is unknown and that we can override the given
> settings.

Good point, will do.

Thanks,
Henrik

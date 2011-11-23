Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1KWMKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:10:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1KWMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:10:35 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: Re: [PATCH 6/8] HID-multitouch: Add egalax ID for Acer Iconia W500
Date: Wed, 23 Nov 2011 13:10:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr> <alpine.LNX.2.00.1111231228260.28728@pobox.suse.cz> <CAN+gG=HUFDxKp7UP8MwvprbKfNTM1Kr14SCphhMw-ZxSMB9z+Q@mail.gmail.com>
In-Reply-To: <CAN+gG=HUFDxKp7UP8MwvprbKfNTM1Kr14SCphhMw-ZxSMB9z+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231310.30111.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 23, 2011 at 12:28, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Wed, 23 Nov 2011, Benjamin Tissoires wrote:
> >> From: Marek Vasut <marek.vasut@gmail.com>
> >> 
> >> This patch adds USB ID for the touchpanel in Acer Iconia W500. The panel
> >> supports up to five fingers, therefore the need for a new addition of
> >> panel types.
> >> 
> >> originally Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > 
> > Before taking this, I'd like to have the credits / signoffs for this
> > patch clarified.
> 
> Sorry for that,
> 
> I cherry-picked Marek's patch and do some modifications.
> I wanted to keep his "from" as he already sent 2 patches that were
> lost in the LKML (mostly because of my fault).
> 
> So, in this one, you have at least my Signed-off-by.
> Marek, will you just answer to this mail with your signed-off-by?
> 
> Cheers,
> Benjamin
> 

I don't really care about who should be the author here, so here you have my SoB 
line.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

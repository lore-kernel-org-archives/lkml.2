Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab1CXOcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:32:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1CXOcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:32:03 -0400
Date: Thu, 24 Mar 2011 15:32:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, chatty@enac.fr,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/2] hid-ntrig: calibration
In-Reply-To: <20110321171550.GA4602@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1103241531130.19969@pobox.suse.cz>
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu> <1299829072-19489-2-git-send-email-rafi@seas.upenn.edu> <20110321171550.GA4602@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, Henrik Rydberg wrote:

> > Adding a function to tell the device to run its calibration routine.
> > A number written to the sysfs specifies the duration of the calibration
> > in milliseconds
> > 
> > Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> > ---
> 
> This is great functionality, and from what it seems, it works. However, 
> the poking at the usb layer makes me wonder if there is another way... 
> Jiri? Dmitry? Awaiting answers from someone more knowledgeable, please 
> find some comments inline.

Actually, let me put it another way -- is there any reason not to have 
this as a functionality provided by HID core code (with driver registering 
callbacks if they want to provide calibration functionality)?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

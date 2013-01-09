Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3AIOwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:52:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab3AIOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:52:37 -0500
Date: Wed, 9 Jan 2013 15:52:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] HID: i2c-hid: add ACPI support
In-Reply-To: <CAN+gG=GrrEdgrCLXvO=xJ6SNeKgHFRobq6RSAfLMfesKkJcijA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1301091551580.12134@pobox.suse.cz>
References: <1357742588-11366-1-git-send-email-mika.westerberg@linux.intel.com> <CAN+gG=GrrEdgrCLXvO=xJ6SNeKgHFRobq6RSAfLMfesKkJcijA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013, Benjamin Tissoires wrote:

> <mika.westerberg@linux.intel.com> wrote:
> > The HID over I2C protocol specification states that when the device is
> > enumerated from ACPI the HID descriptor address can be obtained by
> > executing "_DSM" for the device with function 1. Enable this.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> I'm eager to test it (hopefully next week).
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Perfect. I will wait for your Tested-by: as well before applying to public 
git tree.

Thanks to both of you,

-- 
Jiri Kosina
SUSE Labs

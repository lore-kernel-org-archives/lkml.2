Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2KZN1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:27:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2KZN1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:27:16 -0500
Date: Mon, 26 Nov 2012 14:27:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: hid-input: battery quirk for Apple keyboard
In-Reply-To: <50B22662.4070503@odi.ch>
Message-ID: <alpine.LNX.2.00.1211261426240.12570@pobox.suse.cz>
References: <50B22662.4070503@odi.ch>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2012, Ortwin Glück wrote:

> Support battery capacity on another Apple wireless
> keyboard.

Your patch has been whitespace damaged. I have fixed it by hand and 
applied, but please fix your process for any future patch submissions. 
Thanks.

> NB: most likely all other APPLE_ALU_WIRELESS_* keyboards should be added 
> as well.

I think it's likely true, but I prefer to have it actually tested before 
doing such changes blindly.

Thanks,

-- 
Jiri Kosina
SUSE Labs

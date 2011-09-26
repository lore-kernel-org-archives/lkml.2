Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1IZMUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:20:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1IZMUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:20:12 -0400
Date: Mon, 26 Sep 2011 14:20:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] autodetection of multitouch devices 
In-Reply-To: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Benjamin Tissoires wrote:

> Hi Guys,
> 
> These two patches finally enable the kernel to handle multitouch devices correctly.
> If a device presents in its report descriptors the usage Contact ID, then it is considered as
> a multitouch device and handled by hid-multitouch.

Hi Banjamin,

thanks a lot for working on this. I have now queued the patches in my 
tree.

-- 
Jiri Kosina
SUSE Labs

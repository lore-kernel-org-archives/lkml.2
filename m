Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2DHXx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:53:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab2DHXxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:53:55 -0400
Date: Mon, 9 Apr 2012 01:53:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] hid: Extending the device-driver matching mechanism
In-Reply-To: <20120403105554.GA14201@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1204090152140.24006@pobox.suse.cz>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se> <CAN+gG=EvmTFKmKGaC6T-RKYhUy8U0NqWxqz-k_Gr_w5_rm57Bg@mail.gmail.com> <20120403105554.GA14201@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Henrik Rydberg wrote:

> The simplest solution is probably to defer parsing for drivers known
> from the device list. 

That would unfortunately still break dynamic rebinding of the drivers via 
sysfs bind/unbind facility (which has apparently been already broken wrt. 
report_fixup() callback and I am looking into it right now, but that's a 
different story).

-- 
Jiri Kosina
SUSE Labs

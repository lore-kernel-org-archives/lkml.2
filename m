Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab2K2OA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:00:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2K2OA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:00:26 -0500
Date: Thu, 29 Nov 2012 15:00:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] HID: hid-input factorize hid_input allocation
In-Reply-To: <1353684694-5723-2-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211291459490.25639@pobox.suse.cz>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com> <1353684694-5723-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Benjamin Tissoires wrote:

> This just refactors the allocation of hid_input.
> No semantic changes.

As this is a generic cleanup, I am taking this one through 
for-3.8/upstream branch.

Thanks,

-- 
Jiri Kosina
SUSE Labs

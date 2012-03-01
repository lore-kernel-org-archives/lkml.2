Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995Ab2CAI0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:26:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964870Ab2CAI0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:26:18 -0500
Date: Thu, 1 Mar 2012 09:26:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: pinglinux@gmail.com, peter.hutterer@who-t.net,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: wacom: Add pad buttons reporting on Intuos4
 WL
In-Reply-To: <1330449545-6217-2-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1203010926110.23367@pobox.suse.cz>
References: <1330449545-6217-1-git-send-email-przemo@firszt.eu> <1330449545-6217-2-git-send-email-przemo@firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012, Przemo Firszt wrote:

> This patch adds reporting of 1 wheel button and 8 strip buttons for Intuos4 WL.
> The buttons are reported as BTN_0 to BTN_9. The change of type butstate variable
> is required as the old type 'char' couldn't store state of 9 buttons. The change
> is not affecting Graphire tablet as it only uses first 2 bits of 'butstate'.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

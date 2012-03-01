Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2CAI0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:26:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2CAI0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:26:10 -0500
Date: Thu, 1 Mar 2012 09:26:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: pinglinux@gmail.com, peter.hutterer@who-t.net,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: wacom: report distance for Intuos4 WL
In-Reply-To: <1330449545-6217-1-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1203010926020.23367@pobox.suse.cz>
References: <1330449545-6217-1-git-send-email-przemo@firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012, Przemo Firszt wrote:

> This patch adds reporting of distance of tool to the tablet surface. Maximum
> reported value is 63 (0x3F).

Applied.

-- 
Jiri Kosina
SUSE Labs

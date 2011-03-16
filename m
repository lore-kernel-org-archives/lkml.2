Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1CPPzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:55:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1CPPyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:54:54 -0400
Date: Wed, 16 Mar 2011 16:54:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add support for Ortek PKB-1700
In-Reply-To: <1300290488-8128-1-git-send-email-herton.krzesinski@canonical.com>
Message-ID: <alpine.LNX.2.00.1103161653510.19969@pobox.suse.cz>
References: <1300290488-8128-1-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Herton Ronaldo Krzesinski wrote:

> As reported on http://ubuntuforums.org/showthread.php?t=1594007 the
> PKB-1700 needs same special handling as WKB-2000.

Could you please update Kconfig text and the comment in hid-ortek.c as 
well? It currently refers only to WKB-2000 model.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

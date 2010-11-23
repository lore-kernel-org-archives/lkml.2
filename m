Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0KWKOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:14:34 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:26929 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0KWKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:14:33 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Decompressors: Fix error handling in decompress_unlzma.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 12:14:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231214.05250.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches depend on each other and should be applied in
order. The patches can be applied either alone or on top of
the four patches I sent yesterday.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode

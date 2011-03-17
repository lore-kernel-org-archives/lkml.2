Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1CQIzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:55:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:44082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab1CQIyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:54:55 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: question oh macros and gcc's intelligence
Date: Thu, 17 Mar 2011 08:48:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103170848.57688.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

if I write:

if (le16_to_cpu(p) == CONST) a();

is gcc smart enough to convert CONST to le16 and do
a simple comparison?

	Regards
		Oliver

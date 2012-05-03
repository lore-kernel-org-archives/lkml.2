Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab2ECV6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:58:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51877 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756044Ab2ECV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:58:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19FOY0BRR9FceK4lgvUltEbaCqO0MpuKCknx1ovot
	xFMZeFe8S4SX7A
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v2] video/sis: Use SiS_DRAMType from init.h and annotate it __devinitconst
Date: Thu, 3 May 2012 23:58:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.3; KDE/4.7.4; x86_64; ; )
Cc: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4FA2FD10.6090306@gmx.de>
In-Reply-To: <4FA2FD10.6090306@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205032358.36229.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 03 Mai 2012, 23:48:00 schrieb Florian Tobias Schandinat:
> You can still mark it as __devinitconst, I just wanted to have the array
> inside a C file, not a header. If you agree with this, I'll change your
> new patch that way.
I'm totally fine with this - Thanks,
Peter

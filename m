Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1ECLOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:14:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1ECLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:14:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] audit: support the "standard" <asm-generic/unistd.h>
Date: Tue, 3 May 2011 13:14:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105022254.p42MsDib030320@farm-0023.internal.tilera.com>
In-Reply-To: <201105022254.p42MsDib030320@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031314.39544.arnd@arndb.de>
X-Provags-ID: V02:K0:zA+O7uKntXsFhRN/0vp/y3umqLZna+4urctXhJqImlL
 cyFl3kGTrVW1wvr6gaqqkXd2bEO3QOfdj2Y0hak7HBbk1IWb54
 vQQX6FswfCjk9SY1GlyV4FxrcJQjnCMaqg4WriXevC12FOzB39
 LDRCaZsoNvRcSARWpS/LhNI8Zv7ekdNdw9chzgxSNwCFVFeQKf
 ne58c36/grNaibZib+jzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011, Chris Metcalf wrote:
> Many of the syscalls mentioned in the audit code are not present
> for architectures that implement only the "standard" set of
> Linux syscalls (e.g. openat, but not open, etc.).  This change
> adds proper #ifdefs for all those syscalls.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Looks good, thanks!

Acked-by: Arnd Bergmann <arnd@arndb.de>

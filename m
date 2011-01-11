Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1AKBuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:50:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64697 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1AKBua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IQcnj1mH5GpW+r3hm6pQH3xWHn8R/hyuDUKg9zK4jpPo4x15FinomeipW+qjp0lqxx
         iWNes34+6/WiZt+lhoR3+KpSMpja/qPwSx0m25gLzItmGIcsjBjIKvohF98d83H0NdGs
         9lmu2aczi7xlpNevz0mKyubHBgmTuFROlFMl0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>
Subject: MEMSTICK: My 2 drivers for 2.6.38 inclusion
Date: Tue, 11 Jan 2011 03:50:20 +0200
Message-Id: <1294710624-12379-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following patches hopefully address all comments on my code.

I would really be glad to see them in 2.6.38, as many users request me of doing so.

Best regards,
	Maxim Levitsky



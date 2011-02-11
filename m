Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1BKNwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:52:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53154 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab1BKNwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:52:54 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it
Subject: [PATCH 1/4] RTC: Include information about UIE and PIE in RTC driver proc.
Date: Fri, 11 Feb 2011 11:50:23 -0200
Message-Id: <1297432224-14001-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Fri, Feb 11, 2011 at 10:34, Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br> wrote:
Hi John,

On Thu, Feb 10, 2011 at 21:06, John Stultz <john.stultz@linaro.org> wrote:
>
>> This seems to be mostly formatting changes. Are you sure we wont' break
>> applications expecting the existing format?
>>
> No, I can't be 100% sure, ...

While reworking the patch, I can be 100% sure it would break because it fixed a typo and changed two names, so it was not white space at all.

The reworked patch follows.

Regards,
Marcelo.


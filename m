Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2EVMRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:17:05 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59420 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2EVMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:17:03 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 16:17:02 +0400
Message-ID: <CAMMxdh1Ak2LWeL=3qxTmvfR43E=wSHz5OmSj_irMubz0aK+TgA@mail.gmail.com>
Subject: struct tty_flip_buffer replacement in newer kernels
From: Dmitriy Alekseev <deathonfuneral@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm newbie, working under existed serial driver, adapting it for 2.6.32.
During the compilation I have had several problems, which I
succesfully solved except this one:
error: 'struct tty_struct' has no member named 'flip'
In particular, cound you advice correct replacement of "tty->flip.count"

Thanks
-- 
Best Regards,
Dmitriy Alekseev

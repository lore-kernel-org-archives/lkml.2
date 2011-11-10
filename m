Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab1KJIGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:06:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43450 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643Ab1KJIGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:06:20 -0500
MIME-Version: 1.0
Date: Thu, 10 Nov 2011 09:06:18 +0100
Message-ID: <CAM8FrKJ8OeavZxTBJBONw76UBBzS_mQYMZuS6Chf8+Po6yqDgA@mail.gmail.com>
Subject: ioremap on system memory
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working with a custom based platform based on OMAP-L138.
A driver we are using is ioremapping system memory. It does this to
share data between the GPP and DSP core.
This is not allowed in later kernel versions since ARMv6+ does not support this.

Is there any good(and easy) way to get around this or is it so
fundamentally wrong that the driver should be written from scratch?

Thanks in advance

Med vänliga hälsningar / Best regards
Marcus Folkesson

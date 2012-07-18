Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2GRNDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:03:06 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44134 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2GRNDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:03:04 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
Date: Wed, 18 Jul 2012 18:33:03 +0530
Message-ID: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
Subject: A question on printascii
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,
  I want to use printascii to debug my serial driver. How do I enable
it and use the feature.
  Currently I have enabled in menuconfig and done an extern on the
printascii api, this doesn't seem to work, So any hints for debugging
serial drivers ?

-- 
regards,
Shashidhar Hiremath

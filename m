Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2D1NdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 09:33:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52893 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2D1NdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 09:33:06 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 28 Apr 2012 21:32:23 +0800
Message-ID: <CANFwon3gJOtAAAJJyyCG-d9mZ=Yf_sFk=VfsOEps4BjB6EAOJA@mail.gmail.com>
Subject: [Question] Is that safe if a modules get_task_mm for a very long time?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I check the kernel code found that a lot get_task_mm is use together
with an mmput for a long time.
Do you think I can just an get_task_mm inside a function and use mmput
to release for a long time later?

Thanks,
Hui

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2BZIId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 03:08:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49121 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2BZIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 03:08:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of prasannatsmkumar@gmail.com designates 10.68.227.105 as permitted sender) smtp.mail=prasannatsmkumar@gmail.com; dkim=pass header.i=prasannatsmkumar@gmail.com
Message-ID: <4F49E87B.1050708@gmail.com>
Date: Sun, 26 Feb 2012 13:38:27 +0530
From: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Module Load order
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any specific module load order in Linux? If there is a GPL
driver and binary driver for a particular device which will be loaded?
Is there any logic to load GPL driver built inside the kernel? Or is the
module search and load is handled by some other component (like udev)
and not the kernel? Sorry for my ignorance if I have asked this to a
wrong list.

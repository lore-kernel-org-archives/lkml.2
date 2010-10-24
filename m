Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0JXPFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:05:42 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:44990 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab0JXPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:05:40 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC44B3D.5030404@tremplin-utc.net>
Date: Sun, 24 Oct 2010 17:05:33 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] lis3 accelerator feature update
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> Changes are tested only with I2C interface using 8bit sensor since I don't
> have other possibilities. Some features are not enabled
> by default since I can't test them with all possible configurations.
> Platform data contains field which controls new features.
Thanks Samu for persevering with the automatic power down feature. 
Hopefully I'll find also some time to activate it on the hp_accel side.

For now, I've reviewed the changes and everything looked fine, as well 
as tested them on my HP laptop (with a 12 bits sensor). Although most of 
the changes are not visible on this platform, at least there shouldn't 
be any regression.

Thanks,
Eric

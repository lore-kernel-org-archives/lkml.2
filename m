Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1LIA5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:57:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39785 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1LIA5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:57:21 -0500
Message-ID: <4EE15CED.9030700@lwfinger.net>
Date: Thu, 08 Dec 2011 18:57:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Question about EXPORT of lockdep_init_map
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Is there a reason that you used EXPORT_SYMBOL_GPL for lockdep_init_map, rather 
than the general EXPORT_SYMBOL?

The reason I am asking is that the Broadcom wl hybrid driver will not load into 
a kernel with 'CONFIG_LOCKDEP=y', which is a standard choice for my kernels. I 
don't run wl very often, but I do use it to check the performance of the 
open-source driver b43.

I know how to patch my kernel source to avoid this problem, so that it was only 
a minor inconvenience.

Thanks,

Larry




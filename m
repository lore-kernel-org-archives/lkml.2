Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab2BHSeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:34:25 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:55804 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756342Ab2BHSeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:34:24 -0500
Message-ID: <4F32C01F.1020800@xenotime.net>
Date: Wed, 08 Feb 2012 10:34:07 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
CC: Ingo Molnar <mingo@redhat.com>, dzickus@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: update documentation
References: <4F323B21.7080003@oss.ntt.co.jp>
In-Reply-To: <4F323B21.7080003@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 01:06 AM, Fernando Luis Vázquez Cao wrote:
> The soft and hard lockup detectors are now built on top of the hrtimer
> and perf subsystems. Update the documentation accordingly.


Correction:

+The period of the hrtimer is 2*watchdog_thresh/5, which means it has
+two or three chances two generate an interrupt before the hardware

                      to

+detector kicks in.



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

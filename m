Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2DHNI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 09:08:26 -0400
Received: from smtprelay04.ispgateway.de ([80.67.29.8]:33690 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2DHNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 09:08:20 -0400
Message-ID: <4F818DBA.3080108@ladisch.de>
Date: Sun, 08 Apr 2012 15:08:10 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alex Stone <alex.parchment@yandex.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: Timing 250 versus 1000
References: <4F815FCE.5040002@yandex.ru>
In-Reply-To: <4F815FCE.5040002@yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Stone wrote:
> Is there an important reason why timing in the kernel is set to 250 by default?

It's a compromise.  Read kernel/Kconfig.hz.

> those of us who write a lot of midi driven work, we're still more or
> less required to use some sort of RT kernel to get any degree of
> playback timing accuracy.

The ALSA sequencer timer stopped using the system timer years ago.
And the difference between RT and 'normal' kernels is not the timer
frequency.


Regards,
Clemens

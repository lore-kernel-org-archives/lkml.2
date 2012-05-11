Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2EKHD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:03:57 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:42545 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab2EKHDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:03:55 -0400
Message-ID: <4FACB9D7.5090100@ti.com>
Date: Fri, 11 May 2012 10:03:51 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120509 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Sasha Levin <levinsasha928@gmail.com>, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonicro.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TWL6040: fix build error
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com> <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
In-Reply-To: <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/11/2012 01:49 AM, Paul Gortmaker wrote:
> On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> Fixes build error due to missing of_property_read_u32.
> 
> Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
> this missing header, it needs to have a Kconfig dependency that limits
> it to just being enabled on the platforms where it physically is possible to
> have the hardware.  I'm guessing limiting to ARM would be a good start?

Yes it is only usable on ARM, most specifically on OMAP4+ platforms.
If I make the twl6040 MFD core to depend on ARM (or even on OMAP) this
won't happen again.


-- 
Péter

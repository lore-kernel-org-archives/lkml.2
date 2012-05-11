Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab2EKCut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:50:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42559 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab2EKCur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com> <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 04:50:25 +0200
Message-ID: <CA+1xoqf+Fjt=vMxnFz37t+mH5MBfc7iTZ0OF2fQdryyWk5TSKA@mail.gmail.com>
Subject: Re: [PATCH] TWL6040: fix build error
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dmitry.torokhov@gmail.com, peter.ujfalusi@ti.com,
        broonie@opensource.wolfsonicro.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:49 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> Fixes build error due to missing of_property_read_u32.
>
> Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
> this missing header, it needs to have a Kconfig dependency that limits
> it to just being enabled on the platforms where it physically is possible to
> have the hardware.  I'm guessing limiting to ARM would be a good start?

I'm not sure how the actual hardware looks or even what it does, i
just wanted to make sure that it doesn't break my x86 build. Which is
why I'd rather not modify anything further than what I did in this
patch.

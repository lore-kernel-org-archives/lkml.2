Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab2C1UZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:25:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60605 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab2C1UZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <CADU53JXYSz0sYg6fWjdj_ZjMbZoQVfmz_oD83pSqBL85_4-UmQ@mail.gmail.com>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	<87obshxt4w.fsf@xmission.com>
	<CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
	<87zkc1w6wp.fsf@xmission.com>
	<CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com>
	<CAKaWdxaaKMiwnhP7R786mqHTPs+o=izerZDbUgPBaxyU+XL-2g@mail.gmail.com>
	<C141162D-9164-43D3-9A1F-93156DC7409B@jonmasters.org>
	<CAKaWdxafKU6+s-1-5jqw=JzvUE7ntYUh=T3JOooDWVoiHgq9NA@mail.gmail.com>
	<CADU53JXYSz0sYg6fWjdj_ZjMbZoQVfmz_oD83pSqBL85_4-UmQ@mail.gmail.com>
Date: Thu, 29 Mar 2012 09:25:27 +1300
Message-ID: <CAKaWdxbpuy=op-aHN8YRuNQxY5dX45QRiEmunNxMMUjwgSySBA@mail.gmail.com>
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
From: Keith Chew <keith.chew@gmail.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Jon Masters <jonathan@jonmasters.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Well, someone else may be hitting this and not know. If the situation
> measurably improved by increasing the delay, then it seems like a good
> idea to at least upstream that, regardless if it's perfect?

Please let me carry on with this investigation, before submitting
anything. The reboot=p seems to be really solid, have not had any
issues for over a month. I will be moving back to KBD reboot testing,
and try some more test cases. Will report back soon.

Regards
Keith

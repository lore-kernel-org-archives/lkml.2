Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1KMUgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:36:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1KMUgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:36:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzJMaxs1d-kKj-oc1K-izwRT78dcfjrxA=BAsxpvMioqw@mail.gmail.com>
References: <2407026.akcTO2Ggic@gemini-64>
	<CAPM=9tzJMaxs1d-kKj-oc1K-izwRT78dcfjrxA=BAsxpvMioqw@mail.gmail.com>
Date: Sun, 13 Nov 2011 15:36:46 -0500
Message-ID: <CADnq5_N59MVB6V0xdf=_iMfU6HyW_d1+YZb1DSGyQDOQDo2yOA@mail.gmail.com>
Subject: Re: PROBLEM: Radeon display connector : No monitor connected or
 invalid EDID
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Treeve Jelbert <treeve@scarlet.be>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 1:47 PM, Dave Airlie <airlied@gmail.com> wrote:
> cc Alex.
>
>> Since installing kernel-3.1.1 the screen goes blank during the boot and I am
>> unable to do anything, not even ssh into the box.
>> â€‹
>> linux-3.1.0 worked ok. There are no other changes to the system. Both were
>> built using the same config file.


Can you bisect?

Thanks,

Alex

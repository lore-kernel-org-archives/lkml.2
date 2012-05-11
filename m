Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2EKE1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:27:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51813 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2EKE1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com> <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 10 May 2012 22:27:00 -0600
X-Google-Sender-Auth: 4HGqt_laLwQySTRUOycLXD5nVXY
Message-ID: <CACxGe6vbn7r10KT-q2GGtJatv12prE4ZFJxWsSzPEyLoCuH27A@mail.gmail.com>
Subject: Re: [PATCH] TWL6040: fix build error
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, dmitry.torokhov@gmail.com,
        peter.ujfalusi@ti.com, broonie@opensource.wolfsonicro.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 4:49 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> Fixes build error due to missing of_property_read_u32.
>
> Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
> this missing header, it needs to have a Kconfig dependency that limits
> it to just being enabled on the platforms where it physically is possible to
> have the hardware.  I'm guessing limiting to ARM would be a good start?

IIRC, this hardware is available on x86.  Also, if CONFIG_OF is not
set, then the of_property_read_* functions compile out to do-nothing
stubs.

g.

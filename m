Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1CaGCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:02:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33533 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1CaGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y4OIyLdO2adUXKQWFTgu7hi8ITnsRY7MvQxM1uPUStaiR8QtS/B9lB5Aom1wzSE47V
         Q62PH5Ato1rq15YvL61epjngSAVUqeg4cA6LVR0H76OQGhjpogufVz1+DMfqqI0NYyuF
         d+58jiRt3LNhDsOWKsu1KkBY934bB9HBkAZQA=
MIME-Version: 1.0
In-Reply-To: <m2sju4jrov.fsf@igel.home>
References: <1301050810-11329-1-git-send-email-akinobu.mita@gmail.com>
	<AANLkTikKA2MY6nf+LLyJbNQffX=qYY3eZdpNmwVQc21u@mail.gmail.com>
	<m2sju4jrov.fsf@igel.home>
Date: Thu, 31 Mar 2011 15:02:43 +0900
Message-ID: <AANLkTimuDf+Qo0e_sVuNX5DavOBSu+Gr-VryeD9aSw_9@mail.gmail.com>
Subject: Re: [PATCH] m68k: fix find_next bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Roman Zippel <zippel@linux-m68k.org>,
        linux-m68k@vger.kernel.org,
        Michael Schmitz <schmitzmic@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/31 Andreas Schwab <schwab@linux-m68k.org>:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> Andreas, do you think it's worth keeping (and fixing) the m68k "optimized"
>> versions?
>
> Should be easy to add the required offset >= size checks.

OK, I'll try to fix the optimized version.
Or, could someone who can test on the real hardware fix this problem?

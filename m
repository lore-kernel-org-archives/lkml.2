Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1CBIgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:36:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1CBIgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:36:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=he+IbzT/bs6yPa8lEyYdzX+AByimRMTcdjQgflH6QSIJ7ZwgByKXTeMBcWd7aa5Vkf
         j1I09C3kzu2clJjoL5b66E/TmMAlamSYwGkxuTeEl7D3fySgV0h1cEYl1BQlunXlJJpB
         JayGjTZgLlxyfJcpkEDgwyzrtNBv7XPDwFsWE=
Message-ID: <4D6E016B.50600@gmail.com>
Date: Wed, 02 Mar 2011 09:35:55 +0100
From: "=?ISO-8859-1?Q?Andreas_Bie=DFmann?=" <andreas.devel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        =?ISO-8859-1?Q?Andreas_Bie=DFmann?= <andreas.devel@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in __mark_inode_dirty
References: <1298906733-31427-1-git-send-email-biessmann@corscience.de>	<20110228154314.GA4675@swordfish.minsk.epam.com>	<4D6BC666.4010603@gmail.com>	<20110228162909.GB4675@swordfish.minsk.epam.com> <AANLkTimARkrtmBBgtXmNA=MOD94FWQ8x-qcmLJ8mdQ6o@mail.gmail.com>
In-Reply-To: <AANLkTimARkrtmBBgtXmNA=MOD94FWQ8x-qcmLJ8mdQ6o@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason A. Donenfeld,

Am 01.03.2011 10:00, schrieb Jason A. Donenfeld:
> Can you make an isolated test case to trigger this bug?

in my case it is easily reproduceable. I have an SD-card in our embedded
device (AVR32 AP7000). Some random data is continuously written to an
FAT filesystem on that device. When you pull the card out of the slot
you trigger that NULL pointer dereference.

I will try to reproduce that error on my workstation but this will need
some time. Maybe I can not hit that race on my quad core workstation but
I will give it a try.

regards

Andreas Bieﬂmann

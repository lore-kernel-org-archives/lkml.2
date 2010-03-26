Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0CZDf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:35:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45669 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0CZDfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=HZT3ozTRcJYIYVp65BirgpfhQbS9eNdYOXsXTfu62V/qKD/AUQRy+NLfCKvrFLknCC
         R/6ZZuu+1b3ur7Px8bad+cth5MRN92li2HItbux/l0gu3yoAJg4wjqF2/OE70LOZG3cg
         3u2fJmbfhQrJnoAUTXkKgAiHXTUBe/TA/7rWY=
Message-ID: <4bac2b7b.a115f10a.7d1e.18d7@mx.google.com>
Date: Thu, 25 Mar 2010 20:35:23 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Jens Axboe <jens.axboe@oracle.com>, Pawel S <spawels13@gmail.com>
Cc: linux-kernel@vger.kernel.org, tytso <tytso@mit.edu>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100323132719.GY5768@kernel.dk>
References: <8c4cf08c1003230428t274b8ca8y13d67d65b8830dd7@mail.gmail.com>
	<20100323132719.GY5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 14:27:19 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> It's also been my sneaking suspicion that swap is involved. I had lots
> of RAM in anything I use, even the laptop and workstation. I'll try and
> run some tests with lower memory and force it into swap, I've seen nasty
> hangs that way.
> 
Find out anything useful?

- Ben

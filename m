Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2IXPXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:23:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54174 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab2IXPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120924150048.GB11266@suse.de>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	<20120914212717.GA29307@liondog.tnic>
	<CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	<20120924150048.GB11266@suse.de>
Date: Mon, 24 Sep 2012 18:23:37 +0300
Message-ID: <CA+MedizYAzdKDkGb0qX5XXTTodgWPuX4=ttCY103UXYLi_0Ocg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Nikolay Ulyanitsky <lystor@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2012 18:00, Mel Gorman <mgorman@suse.de> wrote:
> Reverting Mike's patch might fix this Postgres regression but it reintroduces the overhead caused
> by commit 4dcfe102 for other cases.

I just tested pgbench on kernel 3.6-rc7.
There is no performance regression between 3.5.3 and 3.6-rc7 on AMD X6.
Thx

--
With best regards,
Nikolay

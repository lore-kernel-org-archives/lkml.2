Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0CWL2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:28:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:50738 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0CWL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NuRdrW0uQBui7pt3xPhZF+uhD0K+uNcndy1ZaYSs/6kYvYk4b8fJzQuNCqhq9XM5Uw
         BQ/95EgQZZQoTmCoqe42qPfDhx1HBQs5P41dUgzhsNrTbLbC1FaSOhIOjtYDdeA1o8LQ
         IuuAc+V+A3sR+QtrT4WAaMZUmnhn1dSEQsyF0=
MIME-Version: 1.0
Date: Tue, 23 Mar 2010 12:28:31 +0100
Message-ID: <8c4cf08c1003230428t274b8ca8y13d67d65b8830dd7@mail.gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
From: Pawel S <spawels13@gmail.com>
To: linux-kernel@vger.kernel.org, Ben Gamari <bgamari.foss@gmail.com>,
       tytso <tytso@mit.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I am experiencing very similar issue. My system is a regular desktop
PC and it suffers from very high I/O latencies (sometimes desktop
"hangs" for eight seconds or more) when copying large files. I tried
kernels up to 2.6.34-rc2, but without luck. This issue was raised at
Phoronix forums and Arjan (from Intel) noticed it can be VM related:

http://www.phoronix.com/forums/showpost.php?p=114975&postcount=51

Here is my perf timechart where you can notice I/O "steals" CPU from
the other tasks:

http://hotfile.com/dl/30596827/ebe566b/output.svg.gz.html

Regards!

P.S. if there is some way I can help more just let me know please.

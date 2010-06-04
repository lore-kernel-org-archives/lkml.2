Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0FDMAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:00:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0FDMAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:00:40 -0400
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <AANLkTinifUTnjypY-h6Vv2qV9O7O4ZOFurxtrEr-3Rig@mail.gmail.com>
References: <20100520204810.GA19188@think>
	 <AANLkTinifUTnjypY-h6Vv2qV9O7O4ZOFurxtrEr-3Rig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 14:00:43 +0200
Message-ID: <1275652843.27810.39750.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 12:56 +0200, Stijn Devriendt wrote:

> The issue I want to tackle is waking up processes when others go to sleep.
> This means try_to_wake_up() from inside the runqueue lock.


Tejun did something for that:

  http://lkml.org/lkml/2010/5/13/136
  


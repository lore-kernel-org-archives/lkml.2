Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2LOJE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 04:04:29 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:46844 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2LOJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 04:04:26 -0500
Message-ID: <50CC3D17.10902@acm.org>
Date: Sat, 15 Dec 2012 10:04:23 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>
Subject: Re: Deadlock observed in SCSI device removal
References: <CADDb1s0wdZfHTZ8jyKdT4zpsYg4+hYXCSBN5=bY3Q=03wBJT4Q@mail.gmail.com>
In-Reply-To: <CADDb1s0wdZfHTZ8jyKdT4zpsYg4+hYXCSBN5=bY3Q=03wBJT4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/12 05:22, Amit Sahrawat wrote:
> We are using kernel version 3.0.33, and the patch which is mentioned for
> the above problem - is already applied in the kernel.

If the kernel reports that io_schedule() hangs that usually means that 
an I/O request was not finished properly. It would help if you could 
verify whether or not you can reproduce this issue with kernel 3.6.10.

Bart.


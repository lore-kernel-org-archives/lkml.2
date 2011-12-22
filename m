Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1LVJqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:46:54 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46566 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1LVJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:46:52 -0500
Date: Thu, 22 Dec 2011 04:46:52 -0500 (EST)
From: Ramon de C Valle <rcvalle@redhat.com>
Reply-To: Ramon de C Valle <rcvalle@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: brk() system call, RLIMIT_AS, and RLIMIT_DATA in 32-bit compatibility mode
Message-ID: <83712412-35d8-473b-a27d-cf5886be71fd@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <040c0443-00ee-4622-bc8f-41ffb07f7fec@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.9.53]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Notice that from 0xc0000000 upwards it continues expanding the
> program break above 0xc0000000 up to 0xff000000 where it also starts
> failing and returning the current break. Is this an expected
> behaviour when running an application in 64-bit machine in 32-bit
> compatibility mode? Is RLIMIT_AS and RLIMIT_DATA being honoured?

I completely ignored the PER_LINUX32_3GB personality and thought this would be enforced by default in this case.

Thanks,

-- 
Ramon de C Valle / Red Hat Security Response Team

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1KDU1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:27:52 -0400
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:50083 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751220Ab1KDU1u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 4 Nov 2011 13:27:28 -0700
Message-ID: <CAL1RGDXLOXwJJcPXf8z_QAPAcNR6LywYX4OZk-48g24=NqStHQ@mail.gmail.com>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 1:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> At this point should we should have a stable userspace API for the
> layout of /sys/kernel/config/target/srpt/, and a number of legacy module
> parameters have been removed or converted into per endpoint attributes
> as per Roland's feedback.  This code has been getting build testing in
> next the past week, and does not touch any external code.

Given the confidence that the userspace ABI is stable,

Acked-by: Roland Dreier <roland@purestorage.com>

 - R.

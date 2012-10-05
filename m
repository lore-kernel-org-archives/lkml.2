Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2JEN3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab2JEN3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:29:41 -0400
Date: Fri, 5 Oct 2012 15:29:40 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: AutoNUMA27
Message-ID: <20121005132940.GL6793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

because of vger technicalities the AutoNUMA27 submit only reached
linux-mm, so I thought of posting a link here too for reference. If
you're interested to benchmark AutoNUMA using your preferred workload
on NUMA hardware, or even better if you could review the code, you can
find the relevant information here:

  http://www.spinics.net/lists/linux-mm/msg42954.html

Thank you,
Andrea

PS. I fixed the submit script so it won't bounce off linux-kernel
again ;)

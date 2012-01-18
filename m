Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2ARSHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:07:23 -0500
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:48477 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932252Ab2ARSHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <1326836021.16983.38.camel@haakon2.linux-iscsi.org>
References: <1326836021.16983.38.camel@haakon2.linux-iscsi.org>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 18 Jan 2012 10:06:57 -0800
X-Google-Sender-Auth: BqDCFbxKXLbNLD0LrfedLdAX3ss
Message-ID: <CAL1RGDUifg_dD4JVO8O=z=JRrMcAdX1SM3iHwbeA4kBau0Ag5A@mail.gmail.com>
Subject: Re: [GIT PULL]: ib_srpt: Initial SRP target merge for v3.3-rc1
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is definitely OK to go upstream at this point ... we can do further
cleanups once upstream but there isn't anything close to a merge blocker
at this point.

Linus, this has been essentially unchanged since the 3.2 merge window.
Any way we can get this in the 3.3 cycle?

 - R.

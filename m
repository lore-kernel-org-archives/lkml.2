Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2CPSyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:54:12 -0400
Received: from relay03ant.iops.be ([212.53.5.218]:48255 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2CPSyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:54:09 -0400
Message-ID: <4F638C46.30607@acm.org>
Date: Fri, 16 Mar 2012 18:53:58 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com,
        linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein> <4F3A46DD.8030305@ce.jp.nec.com> <4F5F8D82.2040704@acm.org> <4F6300BB.9060503@ce.jp.nec.com>
In-Reply-To: <4F6300BB.9060503@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/12 08:58, Jun'ichi Nomura wrote:
> So, while there might be another race between sd_probe_async
> and scsi_host_remove, I believe your "[PATCH] Fix device
> removal NULL pointer dereference" still makes sense.

You are right, I have been too harsh for my own patch. I'll resend it.

Bart.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0JTT4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:56:19 -0400
Received: from smtp.infotech.no ([82.134.31.41]:46468 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0JTT4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:56:17 -0400
Message-ID: <4CBF495D.3090606@interlog.com>
Date: Wed, 20 Oct 2010 21:56:13 +0200
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux SCSI List <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: remove bogus use of struct execute_work in
 sg
References: <4CBD95C0.6060302@kernel.org>
In-Reply-To: <4CBD95C0.6060302@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-10-19 02:57 PM, Tejun Heo wrote:
> execute_work usage in sg is bogus.  execute_in_process_context() is
> never used and ew is used purely as wrapper around work_struct which
> is superflous.  Use work_struct directly.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

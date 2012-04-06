Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2DFJTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:19:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62430 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DFJT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <1333690029-4991-2-git-send-email-svenkatr@ti.com>
References: <1333690029-4991-1-git-send-email-svenkatr@ti.com> <1333690029-4991-2-git-send-email-svenkatr@ti.com>
From: Santosh Y <santoshsy@gmail.com>
Date: Fri, 6 Apr 2012 14:49:07 +0530
Message-ID: <CALMYJDtqsJkKYQqi-XPmLeAmMxcEEqbRe99uW0L5+ZHtN8DmJg@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi/ufs: Fix evaluation of task_failed status
To: Venkatraman S <svenkatr@ti.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
>                task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
>                task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
>
> -               if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
> +               if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
>                    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
>                        task_result = FAILED;
>        } else {
> --
> 1.7.5.4
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1BLSEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:04:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61875 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1BLSDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cUS0+SPZpPB1t3i4qqpKbPOvGTyNIpcsBTRGUTXVpy8EaL40G6TnnHK+6bhEMyIH3m
         B3UL6zZ2iOkEFqahzZcQSYQyRP3Qm3Cct+lk4thftm/hJjPiaDxbIQ51Pt6XQZ6aM1dE
         iwlNykZAVlXUrjT6p9mXF7S0EGrn51NKM6/g4=
MIME-Version: 1.0
In-Reply-To: <4D56CA32.5060304@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-4-git-send-email-tj@kernel.org>
	<4D56CA32.5060304@kernel.org>
Date: Sat, 12 Feb 2011 19:03:54 +0100
X-Google-Sender-Auth: gcz85o_MrEBUkOhdlxaQq1U6JkQ
Message-ID: <AANLkTikTDAq9vZxp3GP4w203_T_ovPXEzUK+EKM0Gdy5@mail.gmail.com>
Subject: Re: [PATCH 03/26] x86-64, NUMA: Drop @start/last_pfn from initmem_init()
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 6:58 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> it will break 32bit.

Ah, right.  Forgot that part was shared with 32bit.  Will update.  Thanks.

-- 
tejun

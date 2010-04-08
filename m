Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab0DHGtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:49:15 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:48362 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab0DHGtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=im0Una5fMNDQ1eBDGpaykQEnOdlDnBUtLWBaEBO5yL5DlSdD1mk2Tsd56arRiSaPO8
         GZYE+Es+NqLscpmMjcwTEhDVXnh6Rar1uMMyA+c2dZyF8aLPUTu9ObS20qMFGcFwzfMg
         M/YrbcoSvYcSW9S36OAiDB7aEK2bUetWmtYFU=
MIME-Version: 1.0
In-Reply-To: <EAEEEBBE07F4F24C89FEF850CF8C77420142A21107@shzsmsx502.ccr.corp.intel.com>
References: <EAEEEBBE07F4F24C89FEF850CF8C77420142A21107@shzsmsx502.ccr.corp.intel.com>
Date: Thu, 8 Apr 2010 15:49:13 +0900
Message-ID: <z2s28c262361004072349xfb2ab477lc416d8d372f0a008@mail.gmail.com>
Subject: Re: [PATCH] race condition between __purge_vmap_area_lazy() and 
	free_unmap_vmap_area_noflush()
From: Minchan Kim <minchan.kim@gmail.com>
To: "Zhao, Leifu" <leifu.zhao@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 3:36 PM, Zhao, Leifu <leifu.zhao@intel.com> wrote:
> Hi all,
>
> I found a bug in 2.6.28 kernel and got the fix for it, see below bug description, log information and the patch. As I know this bug still exists in at least 2.6.32 kernel. I am new in the kernel development process, can someone tell me what should proceed next?
>

Good catch!.

But it was already fixed.

https://patchwork.kernel.org/patch/89783/

Thanks.


-- 
Kind regards,
Minchan Kim

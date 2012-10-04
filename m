Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2JDEh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:37:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56738 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2JDEh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <2224867.hMfXSgyTsI@avalon>
References: <1349272385-24980-1-git-send-email-prabhakar.lad@ti.com> <2224867.hMfXSgyTsI@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 4 Oct 2012 10:07:35 +0530
Message-ID: <CA+V-a8u_SeTmRLWhpGnbBowgU2SAKYtTuOo6-WjEVFgKogeDoQ@mail.gmail.com>
Subject: Re: [PATCH v5] media: mt9p031/mt9t001/mt9v032: use
 V4L2_CID_TEST_PATTERN for test pattern control
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        LMML <linux-media@vger.kernel.org>,
        VGER <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Oct 3, 2012 at 7:43 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Wednesday 03 October 2012 19:23:05 Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> V4L2_CID_TEST_PATTERN is now a standard control.
>> This patch replaces the user defined control for test
>> pattern to make use of standard control V4L2_CID_TEST_PATTERN.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Jean Delvare <khali@linux-fr.org>
>
> Should I push this patch through my tree ? If so I'll wait until the
> V4L2_CID_TEST_PATTERN control patch hits Mauro's tree.
>
I will issue a pull request for this patch plus
V4L2_CID_TEST_PATTERN today thanks.

Regards,
--Prabhakar

> --
> Regards,
>
> Laurent Pinchart
>

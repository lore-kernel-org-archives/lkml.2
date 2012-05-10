Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab2EJAnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:43:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40773 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2EJAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd8Ofmg+kzUgr26CngaNgcw-MXJ91cS4R+BcMLY7yPxjNw@mail.gmail.com>
References: <1334176305-6183-1-git-send-email-philippedeswert@gmail.com>
	<CAKYAXd8Ofmg+kzUgr26CngaNgcw-MXJ91cS4R+BcMLY7yPxjNw@mail.gmail.com>
Date: Thu, 10 May 2012 09:43:06 +0900
Message-ID: <CAKYAXd9roe8he2bGKiurCsxS3+U5otqQqRXzpB8fVPWak2ow_Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: Avoid null pointer dereference
From: Namjae Jeon <linkinjeon@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe De Swert <philippedeswert@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Chris.

Would you check this patch ?

Thanks.

2012/4/12, Namjae Jeon <linkinjeon@gmail.com>:
> 2012/4/12 Philippe De Swert <philippedeswert@gmail.com>:
>> After the null check on md the code jumped to cmd_done, which then
>> will dereference md in mmc_blk_put. This patch avoids the possible
>> null pointer dereference in that case.
>>
>> Signed-off-by: Philippe De Swert <philippedeswert@gmail.com>
> This patch is good also.
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>

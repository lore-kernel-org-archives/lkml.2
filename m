Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2DFJHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:07:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53008 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2DFJHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <1333583176.23520.34.camel@joe2Laptop>
References: <1333583176.23520.34.camel@joe2Laptop>
From: Santosh Y <santoshsy@gmail.com>
Date: Fri, 6 Apr 2012 14:36:51 +0530
Message-ID: <CALMYJDuvbXC4XLbfVr0Fh4fY-VeEgooxAMz-rU35dWW9TF8r6w@mail.gmail.com>
Subject: Re: scsi/ufs: likely || misuse
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 5:16 AM, Joe Perches <joe@perches.com> wrote:
> Probably this should be && not ||
>
> drivers/scsi/ufs/ufshcd.c:              if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
>                    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
>

Somehow missed this email. Thanks Joe. I see Venkatraman has posted a
patch with the changes.

-- 
~Santosh

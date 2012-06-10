Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2FJVdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 17:33:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64635 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2FJVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 17:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120609091426.GA10170@linux-sh.org>
References: <1339229611-2326-1-git-send-email-elezegarcia@gmail.com>
	<20120609091426.GA10170@linux-sh.org>
Date: Sun, 10 Jun 2012 18:33:10 -0300
Message-ID: <CALF0-+U-FHtb3Z+JEHoY9Jm9yhgeTasQR0nX5AwVM1Ah1+JKAg@mail.gmail.com>
Subject: Re: [PATCH 1/6] sh: fix compiler warning by properly inlining flat_set_persistent()
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 6:14 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Sat, Jun 09, 2012 at 05:13:26AM -0300, Ezequiel Garcia wrote:
>> This patch removes the following warning:
>> fs/binfmt_flat.c:752: warning: unused variable ???persistent???
>> There is neither change in functionality, nor extra code generated.
>>
>> Cc: Paul Mundt <lethal@linux-sh.org>
>> Cc: <linux-sh@vger.kernel.org>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>
> That's what the cast was for, with what gcc version did that stop
> working?

I just realized that I should send a v2 (not the whole series just this one)
correcting the commit message, since there wasn't a warning to fix
in first place.

I'll do this soon.

Regards,
Ezequiel.

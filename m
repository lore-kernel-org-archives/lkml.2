Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2KEXvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:51:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47556 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2KEXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:51:19 -0500
Message-ID: <509850F4.2060205@gmail.com>
Date: Mon, 05 Nov 2012 15:51:16 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jamie Iles <jamie.iles@oracle.com>
CC: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] scripts/sortextable: support objects with more than 64K
 sections.
References: <1352106404-11038-1-git-send-email-jamie.iles@oracle.com>
In-Reply-To: <1352106404-11038-1-git-send-email-jamie.iles@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 01:06 AM, Jamie Iles wrote:
> Building with a large config and -ffunction-sections results in a large
> number of sections and sortextable needs to be able to handle that.
> Implement support for > 64K sections as modpost does.
>
> Cc: David Daney <david.daney@cavium.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
> ---
>   scripts/sortextable.c |   24 ++++++++++++++++++++++++
>   scripts/sortextable.h |   26 +++++++++++++++++++++++---
>   2 files changed, 47 insertions(+), 3 deletions(-)
>

I don't plan on extensively testing this, but I have no objections.

David Daney

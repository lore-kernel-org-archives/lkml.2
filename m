Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1FHQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:01:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49421 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab1FHQBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LrIzcSI+MAy2shtZz2l/EENtKmiZRiGxANXPEwOuuqSPtZoMIrGF1fZ4fklUmBu11+
         bOBZ9FnVuWia0QZmUjnC/3Xd7WhGGp4orxtF9g3A/8871zFGWnndrJfT4gZkDxr8F9OR
         q2M9d6Nf4dnxiYW/tTQ5j99rIGwfZm6+YsLYA=
MIME-Version: 1.0
In-Reply-To: <4DEE56AF.1040601@gmail.com>
References: <4DE0B9D8.3020405@gmail.com>
	<4DE10B4D.50501@gmail.com>
	<4DEE56AF.1040601@gmail.com>
Date: Thu, 9 Jun 2011 00:01:30 +0800
Message-ID: <BANLkTin62G7ZZua5StG7hgnhqdWKiGvt5A@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] ramoops: use module parameters instead of platform
 data if not available
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        stevie.trujillo@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 12:49 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> Use generic module parameters instead of platform data, if platform
> data are not available. This limitation has been introduced with
> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Américo Wang <xiyou.wangcong@gmail.com>
> Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
> ---
> ChangeLog
> - v3: add a check for kzalloc return value;
>      removed cast for kzalloc return value
> - v2: fixed tab/space problem

Looks good, thanks!

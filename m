Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1FHQCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:02:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48073 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1FHQCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZlYHzZSFQytjORSPxmmGQfI/yHPr+EvatUpGC51S6GFPxnbImxn1L5z+VLdgNosErC
         JPUaX4InCxa6KHCDl9HwAXo5KvDkZdymUmN4ktGt9quyS+XkK3NQhHTUp8ygB1cS8idE
         4nMUHivyF0izGH7rSeFwiOZSVqAWqiFOE4T7o=
MIME-Version: 1.0
In-Reply-To: <4DEE5737.9060404@gmail.com>
References: <4DE10B58.1010005@gmail.com>
	<4DEE5737.9060404@gmail.com>
Date: Thu, 9 Jun 2011 00:02:34 +0800
Message-ID: <BANLkTinNXmxMAU+rJfrSTBrGVMGrym8Cow@mail.gmail.com>
Subject: Re: [PATCH 2/2] ramoops: add new line to printks
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stevie.trujillo@gmail.com,
        kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 12:52 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> Add new line to each printk.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Américo Wang <xiyou.wangcong@gmail.com>
> Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>

This change is trivial, and it looks good too.

Thanks.

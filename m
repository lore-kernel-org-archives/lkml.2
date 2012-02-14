Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2BNG1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:27:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43578 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2BNG1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:27:43 -0500
Message-ID: <4F39FEB7.2030605@gmail.com>
Date: Tue, 14 Feb 2012 14:27:03 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: chetan loke <loke.chetan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Making gmail 2 step verification work with git send-email
References: <CAAsGZS5VFgFFx8KCBzqVYhxMFLNqyVMj8hmFwauMYBdS_KjFXw@mail.gmail.com>
In-Reply-To: <CAAsGZS5VFgFFx8KCBzqVYhxMFLNqyVMj8hmFwauMYBdS_KjFXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 11:26 AM, chetan loke wrote:
> Hello,
>
> Ok, I know this is not a kernel question. So apologies...
> While sending a patch to linux-scsi yesterday I had to disable the
> 2-step gmail verification just to send the patch and then enabled it
> again.
>
> How do we make git work in the 2 step gmail mode?

Create a new password, and use --smtp-pass[=<password>].

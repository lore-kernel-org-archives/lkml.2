Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab2JRWhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:37:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44619 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2JRWhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 00:37:15 +0200
Message-ID: <CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
Subject: Re: [PATCH] remove untouched code in kfifo_in
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stefani@seibold.net, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 3:59 PM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
> In kfifo_in marco, one piece of code is arounded by if(0). This code in
> introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
> warning. This warning is not there with the upgrade of gcc version.
>
> This patch just remove this code.

Are you sure?
This code fragment looks like a compiler bomb to detect type mismatch to me...

-- 
Thanks,
//richard

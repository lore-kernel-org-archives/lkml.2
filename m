Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2L1Jrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:47:53 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:33196 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2L1Jru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:47:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAD0Gp_YYu+LQr1rKResm_v3pYd+1M5G9kee7e4RJ1TUML7kq_g@mail.gmail.com>
References: <CAD0Gp_YYu+LQr1rKResm_v3pYd+1M5G9kee7e4RJ1TUML7kq_g@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Fri, 28 Dec 2012 16:47:08 +0700
Message-ID: <CAGdaadYAKtb=BBsxqBPWov6gqYqz=G=8uaBSSTUz_-dxAKSQ-A@mail.gmail.com>
Subject: Re: Bad magic number and
To: sham pavman <shampavman.cg@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 12:19 PM, sham pavman <shampavman.cg@gmail.com> wrote:
> <SNIP>
>  mkfs -t ext4 /dev/sdb


I support what Prashant said (I am not careful here), you should use:
mkfs.ext4 /dev/sdb1

then mount /dev/sdb1

-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com

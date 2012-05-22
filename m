Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2EVWha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:37:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50430 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2EVWh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120523083437.e4d3f7ed9b11aae3c51dc2ae@canb.auug.org.au>
References: <20120523083437.e4d3f7ed9b11aae3c51dc2ae@canb.auug.org.au>
Date: Tue, 22 May 2012 15:37:25 -0700
X-Google-Sender-Auth: vt_o5vLlR-rBhHigVhkox2RypKE
Message-ID: <CAOS58YOK5coLZ1kh+7WDX7+cE83oXJoJRZ0Zzv6C_kzSAV1ZZw@mail.gmail.com>
Subject: Re: linux-next: bad commit in the cgroup tree
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On Tue, May 22, 2012 at 3:34 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> The top commit of the cgroup tree (e4968362bd46 "WIP") should not be in
> linux-next.  In fact it looks like you committed your quilt series by
> accident.
>
> I will use the cgroup tree from next-20120522 for today.

Sorry, I apparently executed git commit in the wrong directory. Fixed.

Thank you.

-- 
tejun

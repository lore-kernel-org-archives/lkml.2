Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0JTO3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:29:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:54486 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0JTO3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:29:54 -0400
Date: Wed, 20 Oct 2010 23:29:39 +0900
To: tj@kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: remove bogus use of struct execute_work in sg
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4CBD95C0.6060302@kernel.org>
References: <4CBD95C0.6060302@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101020232322I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 20 Oct 2010 23:29:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 14:57:36 +0200
Tejun Heo <tj@kernel.org> wrote:

> execute_work usage in sg is bogus.  execute_in_process_context() is
> never used and ew is used purely as wrapper around work_struct which
> is superflous.  Use work_struct directly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/sg.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

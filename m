Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab0LUBeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:34:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42449 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933384Ab0LUBeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:34:36 -0500
Message-ID: <4D100400.7060104@zytor.com>
Date: Mon, 20 Dec 2010 17:33:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: Use this_cpu_ops to optimize code
References: <4D0CD337.4080407@kernel.org>
In-Reply-To: <4D0CD337.4080407@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 07:28 AM, Tejun Heo wrote:
> Peter, these three patches are the x86 ones which were in
> percpu#for-next but should go through x86 tree.  These should be
> applied on top of percpu#this_cpu_ops.

Does that mean the latter is now a stable base that I can pull into -tip?

	-hpa

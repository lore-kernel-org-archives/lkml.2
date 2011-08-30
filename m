Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1H3PYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:24:35 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1H3PYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110829152250.d6427f6ecee4dbd59718cc4f@canb.auug.org.au>
References: <20110829152250.d6427f6ecee4dbd59718cc4f@canb.auug.org.au>
Date: Tue, 30 Aug 2011 23:24:32 +0800
Message-ID: <CAM_iQpXmwb3DhwJ3WbojKUWmbmVL3Qxkx8w8oLnOKYC+=hWO4Q@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm with Linus' tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:22 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> Today's linux-next merge of the scsi-post-merge tree got a conflict in
> arch/cris/include/asm/serial.h between commit 02016bc0381c ("cris: add
> arch/cris/include/asm/serial.h") from Linus' tree and commit f8b20ed71f1b
> ("Fix the following build errors:") from the akpm tree.
>
> There former appears to be a later version of the latter, so I dropped
> the latter.

Yeah, thanks Stephen!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1GAIyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:54:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40257 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab1GAIyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <1309508518-23586-1-git-send-email-chrisf@ijw.co.nz>
References: <1309508518-23586-1-git-send-email-chrisf@ijw.co.nz>
Date: Fri, 1 Jul 2011 16:53:49 +0800
Message-ID: <BANLkTi=ykdWdW_S0H4b7VZ2ODUJATfCpPg@mail.gmail.com>
Subject: Re: [PATCH] kernel: auditfilter: replace kmalloc+memset with kzalloc
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 4:21 PM, Chris Forbes <chrisf@ijw.co.nz> wrote:
> Replaced a kmalloc+memset pair with a single call to kzalloc.
>
> Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

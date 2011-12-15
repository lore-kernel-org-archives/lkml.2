Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab1LOSoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:44:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50034 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759252Ab1LOSoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <4EEA0C39.4050900@canonical.com>
References: <4EEA0C39.4050900@canonical.com>
Date: Thu, 15 Dec 2011 10:44:10 -0800
X-Google-Sender-Auth: A-R2s2Q17xpNYtHGuMl1w3WPiF0
Message-ID: <CAOS58YPj1Qc_dfMc83P3ifRAnKW7d828SBxTZK1dc=wMDb6iXQ@mail.gmail.com>
Subject: Re: WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7/0xb9()
From: Tejun Heo <tj@kernel.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 15, 2011 at 7:03 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Tejun - is your patch from https://lkml.org/lkml/2011/12/5/421 in the
> pipeline ? We've got some test machines that are incurring many instances of
> this warning. I noticed that Wu Fengguang also complained about it in
> https://lkml.org/lkml/2011/11/2/208.

Ooh, I think I forgot to send proper patch for that. Sending it now.

Thanks for reminding me.

-- 
tejun

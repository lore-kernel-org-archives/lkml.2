Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1AYR7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:59:47 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59226 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1AYR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:59:41 -0500
Message-ID: <4D3F0F38.6080904@mvista.com>
Date: Tue, 25 Jan 2011 20:58:16 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anoop P A <anoop.pa@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] set up MSP VPE1 timer.
References: <1295943561-20000-1-git-send-email-anoop.pa@gmail.com> <1295978896.27661.567.camel@paanoop1-desktop>
In-Reply-To: <1295978896.27661.567.camel@paanoop1-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anoop P A wrote:

> Changes since original:
> Corrected repeated word in comment

    These comments should *follow* the --- tear line, or Ralf will have to 
hand-edit them out of your patch. I think I've already written to you about this...

> ---
> VPE1 timer will be required for MIPS_MT modes ( VSMP / SMTC ).
> This patch will setup VPE1 timer irq.This has been tested with
> both SMTC and VSMP

> Signed-off-by: Anoop P A <anoop.pa@gmail.com>

WBR, Sergei


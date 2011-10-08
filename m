Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1JHU4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:56:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55063 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1JHU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:56:28 -0400
Message-ID: <4E90B8F8.3070507@gmail.com>
Date: Sat, 08 Oct 2011 22:56:24 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.6-rt17
References: <alpine.LFD.2.02.1110070046270.3240@ionos>
In-Reply-To: <alpine.LFD.2.02.1110070046270.3240@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 03:15 AM, Thomas Gleixner wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0.6-rt17 release.
>
> After chasing weird RCU stalls and hung task messages for quite some
> time a massive collaborative effort was able to track down and fix
> this showstopper. Explanation from the changelog:
snip.

+static int __init dmi_disable_hpet_msi(const struct dmi_system_id *d)
+{
+	hpet_msi_disable = 1;
+}


I just noticed this from watching build output after upgrading from rt14, shouldn't it return a value?

Also, I sent something about memory cgroups to linux-rt-users, but never received a reply, is that ml still used?

Cheers,
Maarten


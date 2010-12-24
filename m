Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0LXLcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:32:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56005 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0LXLci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:32:38 -0500
Message-ID: <4D148495.4030703@mvista.com>
Date: Fri, 24 Dec 2010 14:31:33 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Anoop P A <anoop.pa@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Select R4K timer lib for all MSP platforms
References: <1290067948.9091.14.camel@paanoop1-desktop>
In-Reply-To: <1290067948.9091.14.camel@paanoop1-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-11-2010 11:12, Anoop P A wrote:

>> From c872cbbe5f475d3bb3cb7f821270cb466eead1f7 Mon Sep 17 00:00:00 2001
> From: Anoop P A<anoop.pa@gmail.com>
> Signed-off-by: Anoop P A<anoop.pa@gmail.com>
> Date: Thu, 18 Nov 2010 01:33:36 +0530
> Subject: [PATCH] Select R4K timer lib for all MSP platforms

    Please don't include this header (except the signoff line) -- Ralf will 
have to manually edit it out.

WBR, Sergei

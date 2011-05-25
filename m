Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1EYKJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:09:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1EYKJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:09:46 -0400
Message-ID: <4DDCD569.2030306@suse.cz>
Date: Wed, 25 May 2011 12:09:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] kbuild: Fix reference to vermagic.h
References: <1306314599-19233-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1306314599-19233-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.5.2011 11:09, Geert Uytterhoeven wrote:
> It's "include/linux/vermagic.h", not "include/vermagic.h"
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
> ---
>   scripts/Makefile.modpost |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

Applied to kbuild-2.6.git#kbuild, thanks.

Michal

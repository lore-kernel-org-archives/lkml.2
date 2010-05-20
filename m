Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab0ETSOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:14:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44614 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0ETSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:14:45 -0400
Message-ID: <4BF57C78.4040606@colorfullife.com>
Date: Thu, 20 May 2010 20:16:24 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] ipc: use shifts to extract seq/idx
References: <20100520065911.GG2516@laptop> <20100520070004.GH2516@laptop>
In-Reply-To: <20100520070004.GH2516@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 09:00 AM, Nick Piggin wrote:
> All the ipc ids and sequences are signed integers, so power of 2
> sequence multiplier does not work so well. Convert it to use shifts,
> which improves generated code particularly in ipc_lock/ipc_lock_check
> fast paths.
>
>    
Have you checked the asm output?
I would expect that gcc auto-optimizes constant divides by power-of-two.

--
     Manfred

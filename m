Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0DOQdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:33:09 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:55045 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0DOQdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:33:06 -0400
Message-ID: <4BC73FC9.1090007@colorfullife.com>
Date: Thu, 15 Apr 2010 18:33:13 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       zach.brown@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in semtimedop
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com> <1271098163-3663-2-git-send-email-chris.mason@oracle.com> <4BC4A6B2.1090906@colorfullife.com> <20100413173941.GI13327@think> <20100413180945.GD5683@laptop> <20100413181937.GM13327@think> <4BC5EA75.9090803@colorfullife.com> <20100414173319.GA3228@think> <4BC61370.7020700@colorfullife.com> <20100414195003.GE3228@think>
In-Reply-To: <20100414195003.GE3228@think>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 09:50 PM, Chris Mason wrote:
> On a big system I saw about 4000 semaphores total.  The database will
> just allocate as many as it can into a single array and keep creating
> arrays until it has all it needs.
>
>    
What happens if SEMMSL is reduced (first entry in /proc/sys/kernel/sem)?

--
     Manfred

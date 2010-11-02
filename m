Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0KBUMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0KBUL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:11:56 -0400
Message-ID: <4CD0707F.7080709@redhat.com>
Date: Tue, 02 Nov 2010 16:11:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
References: <1286265215-9025-1-git-send-email-walken@google.com> <1286265215-9025-3-git-send-email-walken@google.com> <4CAB628D.3030205@redhat.com> <AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com> <20101008043956.GA25662@google.com> <4CAF1B90.3080703@redhat.com> <AANLkTinWxTT=+m_fAudc080OUMwacSefnMbSMBFZgPMH@mail.gmail.com> <20101009012204.GA17458@google.com> <20101102200518.GA9229@google.com>
In-Reply-To: <20101102200518.GA9229@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 04:05 PM, Michel Lespinasse wrote:

> Release page reference during page fault retry
>
> This slipped by when unifying the filemap and swap versions of
> lock_page_or_retry()...
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

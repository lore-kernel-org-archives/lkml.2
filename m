Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2GaUyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:54:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2GaUyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:54:08 -0400
Message-ID: <501845E1.8020605@redhat.com>
Date: Tue, 31 Jul 2012 16:53:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] mm, thp: Preserve pgprot across huge page split
References: <20120731191204.540691987@chello.nl> <20120731192808.585844380@chello.nl>
In-Reply-To: <20120731192808.585844380@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:12 PM, Peter Zijlstra wrote:

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1GOW3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:29:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48291 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1GOW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:29:04 -0400
Message-ID: <4E20BF26.2050900@canonical.com>
Date: Fri, 15 Jul 2011 18:28:54 -0400
From: Ayan George <ayan.george@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Phillip Susi <psusi@cfl.rr.com>, linux-kernel@vger.kernel.org
Subject: Re: loop device auto release patch
References: <4E1F3BE0.8040506@ayan.net>	<4E209132.7000704@cfl.rr.com> <20110715121903.dc543613.akpm@linux-foundation.org>
In-Reply-To: <20110715121903.dc543613.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 03:19 PM, Andrew Morton wrote:
> Still, splitting it into two patches (in which the bugfix is staged
> first) would be advantageous for people who might wish to backport the
> fix into earlier kernels.
>

Okay -- I'll submit two smaller patches and I'll early next week.

-ayan

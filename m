Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0DIKyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:54:38 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:39292 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0DIKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:54:35 -0400
Message-ID: <4BBF0762.8040505@lumino.de>
Date: Fri, 09 Apr 2010 12:54:26 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <20100408.051453.231567150.davem@davemloft.net> <4BBDCC6E.3060702@lumino.de> <201004081615.01151.arnd@arndb.de>
In-Reply-To: <201004081615.01151.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 04:15 PM, Arnd Bergmann wrote:
> /* returns one if we got the lock, zero if someone else holds it */
> bool hashlock_addr(volatile void *addr);
>   
I don't see how (to do FUTEX) a hashlock can be implemented in a way
that we stay in user mode when locking it and - if it's already locked -
we do a Kernel call for waiting on it being unlocked by another thread.
(This is what FUTEX does.)

-Michael

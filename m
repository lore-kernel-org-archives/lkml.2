Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2CGVxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:53:00 -0500
Received: from fifo99.com ([67.223.236.141]:50905 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030322Ab2CGVw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:52:58 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 16:52:58 EST
Message-ID: <4F57D739.50603@fifo99.com>
Date: Wed, 07 Mar 2012 13:46:34 -0800
From: Daniel Walker <dwalker@fifo99.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] staging: Android updates
References: <1331156046.2191.185.camel@work-vm>
In-Reply-To: <1331156046.2191.185.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 01:34 PM, John Stultz wrote:
>        android: ram_console: move footer strings
>        android: ram_console: drop early buffer support
>        android: ram_console: drop verbose ram_console support
>        android: ram_console: split out persistent ram

What are the differences between mtdoops/ramoops and ram_console? My 
research showed they had different ways of saving the memory, but didn't 
very similar things.

Daniel

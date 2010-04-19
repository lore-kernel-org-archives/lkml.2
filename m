Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0DSG6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 02:58:07 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:45106 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0DSG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 02:58:05 -0400
Message-ID: <4BCBFEE3.8020509@codesourcery.com>
Date: Mon, 19 Apr 2010 14:57:39 +0800
From: Jie Zhang <jie@codesourcery.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Ben Gamari <bgamari.foss@gmail.com>, gcc@gcc.gnu.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
References: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com> <4bcbebb3.9653f10a.3be1.ffffe0ef@mx.google.com> <4BCBFBA9.9040606@gmail.com>
In-Reply-To: <4BCBFBA9.9040606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 02:43 PM, Justin P. Mattock wrote:
> I couldn't resist..(had to play),
> anyways I looked through the reports
> but didn't see anything that was
> familiar. so I went and created an entry:
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43791
>
Thanks. Please add a preprocessed source file so people can reproduce 
your issue.


-- 
Jie Zhang
CodeSourcery
(650) 331-3385 x735

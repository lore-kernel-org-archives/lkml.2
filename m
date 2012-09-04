Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2IDG74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:59:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59784 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2IDG71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:59:27 -0400
Message-ID: <5045A6C9.8000101@gmail.com>
Date: Tue, 04 Sep 2012 14:59:21 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sachin Agarwalla <sachin.agarwalla@cse.iitkgp.ernet.in>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: need help on development of linux kernel
References: <2132522857.5273.1346300120620.JavaMail.root@mailstore2.iitkgp.ac.in>
In-Reply-To: <2132522857.5273.1346300120620.JavaMail.root@mailstore2.iitkgp.ac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 12:15 PM, Sachin Agarwalla wrote:
> Dear Sir/Madam,
>    I have some questions on development of linux kernel as follows:-
> 1.I want to know the location of files in linux kernel source code that contains timer initialization and scheduler part.

Scheduler source code is in kernel/sched/* files.

> 2.Also I want to know location of header files(or library files) that are present in the above files.

include/linux/sched.h

> 3.Is there any version of linux kernel that uses openmp or inteltbb or parallelc tool.

No, kernel doesn't use any libraries including libc.


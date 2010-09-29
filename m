Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0I2WQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:16:35 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3243 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0I2WQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:16:34 -0400
Message-ID: <4CA3BABC.7020505@caviumnetworks.com>
Date: Wed, 29 Sep 2010 15:16:28 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andreas Saebjoernsen <andreas@digitalplaywright.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: interpreting semantics of ipc system call
References: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com>
In-Reply-To: <AANLkTik8auzhRB00fRWxbmZKOKg+T87ZZa07ydDAGp=f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 22:16:33.0932 (UTC) FILETIME=[F9AF2CC0:01CB6023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2010 03:03 PM, Andreas Saebjoernsen wrote:
> We are developing a simulator that can simulate any specimen x86 linux program.
> Our simulator has a simulated memory, unlike the concrete memory state of
> tools like Valgrind, so that we can do concrete symbolic execution. Instead of
> reimplementing the system calls we marshal the system calls called by
> the specimen.
>
> I am currently working on marshaling calls to the ipc system call (system
> call 117) which has the following signature
>
> int ipc(unsigned int call, int first, int second, int third, void
> *ptr, long fifth)
>
> I have a problem interpreting what the size is of the data structure
> pointed to by
> the 'void*', and I have been unable to locate good documentation or code on the
> semantics of this system call.
 >
 > Could you please help me interpret the size of the data structure
 > pointed to by the
 > 'void*' or point me to documentation/code for the ipc system call?

man 2 
{ipc,msgctl,msgget,msgrcv,msgsnd,semctl,semget,semop,semtimedop,shmat,shmctl,shmdt,shmget}

Also look at the source code for the system call in ipc/syscall.c and 
the glibc sources.

David Daney


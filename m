Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab0GHTtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0GHTtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:49:01 -0400
Message-ID: <4C362B49.4060005@redhat.com>
Date: Thu, 08 Jul 2010 15:47:21 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: jens.axboe@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Don Zickus <dzickus@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: cpu softplug kernel hang
References: <4C361E6C.2080107@redhat.com>
In-Reply-To: <4C361E6C.2080107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm planning on fixing this by rewriting this code and using stop_machine_run()
> to synchronize the cpus instead of doing it in the ipi_handler.  
>
> Unless, of course, someone has a better suggestion.
>
>   

Heh ... stop_machine() isn't going to work because of the scheduling
restriction :/

> P.
>
>
>
>
>   

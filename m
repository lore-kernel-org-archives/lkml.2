Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1BEVqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 16:46:03 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62611
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403Ab1BEVqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 16:46:01 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 16:46:00 EST
X-IronPort-AV: E=Sophos;i="4.60,432,1291590000"; 
   d="scan'208";a="87499139"
Message-ID: <4D4DC2D6.8030905@ens-lyon.org>
Date: Sat, 05 Feb 2011 22:36:22 +0100
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Nikolaus Rath <Nikolaus@rath.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: virt_to_page for userspace pointers
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu> <878vxuxkfr.fsf@inspiron.ap.columbia.edu>
In-Reply-To: <878vxuxkfr.fsf@inspiron.ap.columbia.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/02/2011 22:04, Nikolaus Rath a écrit :
> Nikolaus Rath <Nikolaus@rath.org> writes:
>   
>> Is there a way that my own kernel module can "reverse" this mmap call?
>> I.e. given the userspace pointer, how do I get access to the physical
>> location of the memory that has been mapped?
>>     
> Ok, after some studying I think I can ask the question in a better way:
>
> Is there an equivalent function to virt_to_page (and virt_to_phys) that
> works with userspace pointers? Or do I have to manually walk through the
> page tables? In the later case, are there any examples of this kind of
> search that I could use as a basis?
>   

You probably want get_user_pages() (or get_user_pages_fast()).

Brice


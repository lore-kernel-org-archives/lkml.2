Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3AELXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:23:36 -0500
Received: from intranet.asianux.com ([58.214.24.6]:45127 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3AELXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:23:34 -0500
X-Spam-Score: -100.7
Message-ID: <50E80D6A.2050702@asianux.com>
Date: Sat, 05 Jan 2013 19:24:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: strcpy and strncpy,
 src length checking issue.
References: <50CAA1F2.9000003@asianux.com> <CAJ6Av5MP8gjck=WqjLJMLEtHbbaMOT2aFxExP4YkGScE-O0L8A@mail.gmail.com>
In-Reply-To: <CAJ6Av5MP8gjck=WqjLJMLEtHbbaMOT2aFxExP4YkGScE-O0L8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月05日 19:17, Omar Ramirez Luna 写道:
> Hi,
> 
> On Thu, Dec 13, 2012 at 9:50 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>   in drivers/staging/tidspbridge/rmgr/proc.c:
>>
>>     if strlen(drv_datap->base_img) == size, will pass checking (line 397)
>>     the size is the full length of exec_file (line 382, line 468..469)
>>     strcpy causes issue: src len is strlen(drv_datap->base_img) + '\0'. (line 400)
> 
> Good catch.
> 
>>     strncpy seems also has issue: need use size instead of strlen(iva_img) + 1. (line 402..403)
> 
> This code is not used, it is best to remove it.
> 

  thank you.

  :-)

gchen


> Cheers,
> 
> Omar
> 
> 


-- 
Chen Gang

Asianux Corporation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2FKSF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab2FKSF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:05:57 -0400
Message-ID: <4FD629A3.4060908@redhat.com>
Date: Mon, 11 Jun 2012 14:23:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: Roland Dreier <roland@kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: Only register mce_decode_chain once
References: <1338488391-20755-1-git-send-email-roland@kernel.org> <4FC82AFB.6020209@linux.intel.com> <CAG4TOxNUjL6EbOFKy12=deBNZGkwezkx3=tu9a1U6NpUGTs3CA@mail.gmail.com> <4FC86C59.5030409@linux.intel.com>
In-Reply-To: <4FC86C59.5030409@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-06-2012 04:16, Chen Gong escreveu:
> 于 2012/6/1 14:04, Roland Dreier 写道:
>>> Hi, please refer this: https://lkml.org/lkml/2012/5/8/62
>>
>> Yes, your fix looks identical.  However your changelog makes it
>> sound a bit less severe that it is: on my system at least, it is
>> an immediate hard hang the first time sb_edac is loaded, rather
>> than requiring module unload or any memory errors to trigger.
>>
>> Anyway I think the fix needs to get merged right away, and your
>> patch is fine with me.
>>
>> - R. --
> 
> Mauro told me some days before he will put this patch(with others) on
> another tree, test and then merge it.

It should be already at -next. I'll be likely sending them upstream tomorrow.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



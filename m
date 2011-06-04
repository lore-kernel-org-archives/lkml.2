Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1FDEZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 00:25:16 -0400
Received: from mx12.lb01.inode.at ([62.99.145.14]:40794 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750880Ab1FDEZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 00:25:14 -0400
X-Greylist: delayed 84073 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jun 2011 00:25:14 EDT
Message-ID: <4DE9B3A6.9090801@reinelt.co.at>
Date: Sat, 04 Jun 2011 06:25:10 +0200
From: Michael Reinelt <michael@reinelt.co.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.0.7) Gecko/20061013 Thunderbird/1.5.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: mtrr_cleanup: can not find optimal value
References: <4DE86B3D.1080806@reinelt.co.at> <BANLkTikoQ1E9zJAUGeQTHs-ffLK=R7Wdsw@mail.gmail.com>
In-Reply-To: <BANLkTikoQ1E9zJAUGeQTHs-ffLK=R7Wdsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Am 2011-06-03 07:26, schrieb Yinghai Lu:
...
>> So I'm asking for some advice how to manually tune the MTRR's.
> ...
>>   gran_size: 8M  chunk_size: 32M         num_reg: 7      lose cover RAM: 7M
> ...
> you can append "mtrr_gran_size=8M mtrr_chunk_size=32M" in boot command line.

Works fine, thank you!

Any hint *why* you choose this line?


regards, Michael

-- 
Michael Reinelt <michael@reinelt.co.at>
http://home.pages.at/reinelt
GPG-Key 0xDF13BA50
ICQ #288386781

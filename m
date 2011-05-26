Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1EZCEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:04:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59833 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1EZCEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:04:37 -0400
Message-ID: <4DDDB522.6070204@oracle.com>
Date: Wed, 25 May 2011 19:04:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: =?windows-1252?Q?Re=3A_2=2E6=2E39-git10_--_sound/soc/codec?=
 =?windows-1252?Q?s/ak4641=2Ec=3A524=3A6=3A_error=3A_=91GPIOF=5FOUT=5F?=
 =?windows-1252?Q?INIT=5FLOW=92_undeclared_=28first_use_in_this?=
 =?windows-1252?Q?_function=29?=
References: <BANLkTik5tiX5P3dF6to_DpyX+NJ0CQAF_g@mail.gmail.com>
In-Reply-To: <BANLkTik5tiX5P3dF6to_DpyX+NJ0CQAF_g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DDDB532.011C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/11 18:51, Miles Lane wrote:
> sound/soc/codecs/ak4641.c: In function ‘ak4641_probe’:
> sound/soc/codecs/ak4641.c:524:6: error: ‘GPIOF_OUT_INIT_LOW’
> undeclared (first use in this function)
> sound/soc/codecs/ak4641.c:524:6: note: each undeclared identifier is
> reported only once for each function it appears in
> make[3]: *** [sound/soc/codecs/ak4641.o] Error 1

Yes, I know all about that one.

A patch for various gpio header files has been sent, but the GPIO
maintainer has remained quiet.  :(

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

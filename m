Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2KGDsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:48:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24400 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab2KGDsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:48:07 -0500
X-IronPort-AV: E=Sophos;i="4.80,726,1344182400"; 
   d="scan'208";a="6151639"
Message-ID: <5099D99B.8070401@cn.fujitsu.com>
Date: Wed, 07 Nov 2012 11:46:35 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, miaox@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Do not change worker's running cpu in cmci_rediscover().
References: <1351479710-9144-1-git-send-email-tangchen@cn.fujitsu.com> <5098F1C6.1010602@cn.fujitsu.com> <20121106144405.GC9558@x1.osrc.amd.com>
In-Reply-To: <20121106144405.GC9558@x1.osrc.amd.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 11:46:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 11:47:10,
	Serialize complete at 2012/11/07 11:47:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 10:44 PM, Borislav Petkov wrote:
> On Tue, Nov 06, 2012 at 07:17:26PM +0800, Tang Chen wrote:
>> Hi Tony, Borislav,
>>
>> Would you please help to review this patch ?
>
> I'm guessing mingo or hpa haven't pulled yet:
>
> http://marc.info/?l=linux-kernel&m=135163452500984

Hum, thank you very much for the info. :)

>
> Thanks.
>


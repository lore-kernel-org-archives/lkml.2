Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1DMRSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab1DMRSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:18:09 -0400
Message-ID: <4DA5DAC2.9030404@redhat.com>
Date: Wed, 13 Apr 2011 13:17:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v2] x86, MCE: Drop default decoding notifier
References: <20110413132409.GB1900@gere.osrc.amd.com> <1302701810-2471-2-git-send-email-bp@amd64.org> <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab> <4DA5B1B1.5090905@redhat.com> <20110413142648.GB2791@aftab> <20110413143642.GC2791@aftab> <4DA5D6CC.9090500@redhat.com> <987664A83D2D224EAE907B061CE93D5301A97212BD@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301A97212BD@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/13/2011 01:13 PM, Luck, Tony wrote:
>> [Hardware Error]:  Run the above through 'mcelog --ascii' to decode.
>>
>> potentially many, many times.  The problem still is that there is no
>> output to decode (in the default case).
>>     
> printk_once()?
>   
I don't think that applies here (but you might have a different idea of
what the code needs to look like) as the printk has to happen for *each*
UC error, but never for CE errors :/.

P.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1CXPlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:41:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19628 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1CXPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:41:22 -0400
Message-ID: <4D8B65E1.4080606@kernel.org>
Date: Thu, 24 Mar 2011 08:40:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Waychison <mikew@google.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-watchdog@vger.kernel.org, Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH -v3 -resend] watchdog, SP5100: Check if firmware has	set
 correct value in tcobase.
References: <20110311222129.GA3168@dumpdata.com> <alpine.DEB.2.00.1103161150010.3382@kaball-desktop> <alpine.DEB.2.00.1103161442210.3382@kaball-desktop> <4D80F992.10603@kernel.org> <alpine.DEB.2.00.1103161757040.3382@kaball-desktop> <4D812180.5030102@kernel.org> <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com> <4D812919.30706@kernel.org> <20110317022331.GA3528@dumpdata.com> <4D8AD791.9010602@kernel.org> <20110324083120.GC4968@infomag.iguana.be>
In-Reply-To: <20110324083120.GC4968@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D8B65F3.0096,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 01:31 AM, Wim Van Sebroeck wrote:
>
> This patch is in linux-2.6-watchdog-next for a week now. Will go upstream to linus.

Thanks.


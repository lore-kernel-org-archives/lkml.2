Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab2GDFNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:11 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:2271 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab2GDFNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:06 -0400
X-Loopcount0: from 10.170.28.41
From: <Srinivas_G_Gowda@Dell.com>
To: <minyard@acm.org>
CC: <tcminyard@gmail.com>, <mjg59@srcf.ucam.org>, <andi@firstfloor.org>,
        <linux-kernel@vger.kernel.org>,
        <openipmi-developer@lists.sourceforge.net>, <jharg93@gmail.com>
Date: Tue, 3 Jul 2012 22:11:44 -0700
Subject: Re: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
Thread-Topic: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
Thread-Index: Ac1Zo5OgKfwCfmaoREWqIGCjAJkIfA==
Message-ID: <4FF3D090.8000403@dell.com>
References: <4FEC8931.5020001@dell.com> <4FEC8A28.4070806@dell.com>
 <m2k3yrgf4d.fsf@firstfloor.org> <20120629123001.GA26545@srcf.ucam.org>
 <4FEDBB3C.7080105@acm.org>
In-Reply-To: <4FEDBB3C.7080105@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 07:57 PM, Corey Minyard wrote:
>  seems to me that it's better to directly query what is running on the 
> target to know what is running on it, but perhaps that's a security 
> problem waiting to happen.  And perhaps it's better to have a small 
> program set this at startup, since this operation will currently fail on 
> the majority of systems out there.

Hi All,
The intend of this patch was not to really workaround any issues, the aim was for the management software to use this data. I think Corey summed it up pretty well in his previous comment. Management software associated with BMC usually use this information to let the users know about the OS that is using the BMC. Generally there are 3rd party application software that goes and pretty much fills up the OS env information and the management software uses this. My intend was why don't we get this information loaded by the driver itself. If there are applications that wants to rewrite it, so be it..! 
Rather than just have a static entry such as 'Linux' I could probably write the version number and more(distro name etc.. ) 

Thoughts.. ? 


I know there were some concerns with the security aspect, Can you please let me know what kind of security holes we could be looking at ? 




Thanks,
G


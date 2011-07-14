Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1GNBaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 21:30:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53934 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1GNBay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 21:30:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1E46CA.9030007@jp.fujitsu.com>
Date: Thu, 14 Jul 2011 10:30:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: jmorris@namei.org
CC: torvalds@linux-foundation.org, neilb@suse.de, solar@openwall.com,
        segoon@openwall.com, linux-kernel@vger.kernel.org, gregkh@suse.de,
        akpm@linux-foundation.org, davem@davemloft.net,
        kernel-hardening@lists.openwall.com, jslaby@suse.cz,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        eparis@redhat.com, sds@tycho.nsa.gov
Subject: Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110707075610.GA3411@albatros> <20110707081930.GA4393@albatros> <20110712132723.GA3193@albatros> <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com> <20110713091408.0d456352@notabene.brown> <20110713063142.GA19976@openwall.com> <20110713170657.59dae548@notabene.brown> <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com> <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/14 9:11), James Morris wrote:
> On Wed, 13 Jul 2011, Linus Torvalds wrote:
> 
>> It sounds like people are effectively Ack'ing the patch, but with this
>> kind of patch I don't want to add the "implicit Ack" that I often do
>> for regular stuff.
>>
>> So could people who think that the patch is ok in its current form
>> just send me their acked-by or reviewed-by? I haven't heard any actual
>> objection to it, and I think it's valid for the current -rc.
>>
>> Alternatively, feel free to send a comment like "I think it's the
>> right thing, but maybe it should wait for the next merge window"..
> 
> Count me in the latter.
> 
> It does look ok to me, but I'd be happier if it had more testing first (in 
> -mm perhaps).  I think some security folk may be on summer vacation, too.

I don't think I am best person to take ack. but I also don't want to hesitate
to help Solar's good improvemnt.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

And I'll second James. next mere window is probably safer.

Thanks.


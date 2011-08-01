Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1HAUnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:43:50 -0400
Received: from mail.tpi.com ([70.99.223.143]:3096 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab1HAUnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:43:45 -0400
Message-ID: <4E370FFA.7050106@canonical.com>
Date: Mon, 01 Aug 2011 14:43:38 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, dan@aloni.org,
        davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        stable@vger.kernel.org
Subject: Re: [stable] [PATCH] [26/98] af_unix: Only allow recv on connected
 seqpacket sockets.
References: <20110726534.972201586@firstfloor.org> <20110727003518.6DA772403FF@tassilo.jf.intel.com> <4E3035BE.6090908@canonical.com> <m1sjprfryg.fsf@fess.ebiederm.org> <20110801200857.GE27083@one.firstfloor.org>
In-Reply-To: <20110801200857.GE27083@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 02:08 PM, Andi Kleen wrote:
>> For 2.6.38, and Andi's 2.6.35 which has the potential for an
>> unprivileged process to trigger an oops, it seems irresponsible to me to
>> not include this change.  People who exploit kernel flaws seem good at
>> taking random Oops's and converting them into methods for privilege
>> escalation.
>
> I'll ship 2.6.25.14 without the patch, but can you guys please come to a
> conclusion whether the patch is useful or not. I'll reconsider it for .15.
>
> Thanks,
>
> -Andi
>

I'd go with Eric's assessment. He knows way more about this then I do. I 
am much less confident that the problem Ubuntu experienced with 2.6.35 
was related, it only felt the same (similar network issues).

rtg
-- 
Tim Gardner tim.gardner@canonical.com

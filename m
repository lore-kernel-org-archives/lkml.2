Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0HPTk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:40:56 -0400
Received: from claw.goop.org ([74.207.240.146]:36966 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0HPTk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:40:56 -0400
Message-ID: <4C699446.60309@goop.org>
Date: Mon, 16 Aug 2010 12:40:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] paravirt: noreplace-paravirt is implemented for x86 and
 ia-64
References: <alpine.LNX.2.00.1008111832510.2702@pobox.suse.cz> <4C62D309.5010909@goop.org> <alpine.LNX.2.00.1008161503550.1019@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1008161503550.1019@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/16/2010 06:04 AM, Jiri Kosina wrote:
> On Wed, 11 Aug 2010, Jeremy Fitzhardinge wrote:
>
>>  On 08/11/2010 09:34 AM, Jiri Kosina wrote:
>>> kernel-parameters.txt lists 'noreplace-paravirt' parameter as being
>>> limited to X86-32, which is incorrect -- it's actually supported by
>>> x86-32, x86-64 and ia-64.
>>>
>>> Signed-off-by: Jiri Kosina<jkosina@suse.cz>
>> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Thanks. As I haven't found the patch in linux-next as of today, I'll be 
> taking it through trivial queue.
Yes, thanks.  I didn't pick it up.

    J


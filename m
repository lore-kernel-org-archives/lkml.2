Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1FJRjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:39:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43584 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1FJRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tGRM6Oay7ADKiES3ldnmkwVFLLDhsqGOlbXnTp3ereDtPJD+QUyzDB7kxQ2cFGuiGh
         5XkNDouaf8SR/CA/XSH+/DW7GM2d3RZjzUxxwue9EdOfRnzq53AlZkl4hk/wET2Jk/Ti
         eIqC1IsQ97jzhgkHXbtNjU/pQ5ScjjIwBRZmo=
Message-ID: <4DF256E1.4010703@pobox.com>
Date: Fri, 10 Jun 2011 13:39:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Tejun Heo <htejun@gmail.com>, Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <20110425162242.GB30828@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com> <20110426135027.GI878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com> <20110426155229.GM878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com> <20110430140109.GJ29280@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com> <20110525094127.GF10146@htj.dyndns.org> <4DF20E03.9030502@teksavvy.com> <20110610140155.GJ15235@htj.dyndns.org> <4DF25526.9010800@teksavvy.com>
In-Reply-To: <4DF25526.9010800@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 01:32 PM, Mark Lord wrote:
> On 11-06-10 10:01 AM, Tejun Heo wrote:
>> Hello,
>>
>> (cc'ing Jeff)
>>
>> On Fri, Jun 10, 2011 at 08:28:51AM -0400, Mark Lord wrote:
>>> Tejun, did this ever go upstream and to -stable ??
>>> I'm asking because I see the same issue with other SATA controllers,
>>> in particular with sata_sil boards.  Hot plug generally works _once_
>>> per port, and then stops working.
>>
>> The patch is still pending,
>>
>>   http://article.gmane.org/gmane.linux.ide/49613
>>
>> I don't think it would be wise to include the patch for -stable tho.
>> It's not a regression fix and has some possibility of introducing
>> regressions, so....
>
> Not a regression fix?  Excuse me?
> SATA hotplug always used to work fine,
> and is more or less essential to reboot-free operations.

I can move it from #upstream (linux-next) to #upstream-fixes, if we feel 
it is sufficient urgent.  It seemed like it needed more testing, but 
maybe the best way to do that is #upstream-fixes?

Was mainly a -rc question, to me.

	Jeff




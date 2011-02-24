Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1BXOKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:10:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1BXOKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:10:14 -0500
Message-ID: <4D6666A5.3010303@redhat.com>
Date: Thu, 24 Feb 2011 11:09:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: David Sterba <dsterba@suse.cz>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] i7core_edac: fix misuse of logical operation
 in place of bitop
References: <20110221144146.GE5766@ds.suse.cz> <20110224140541.GB11239@aftab>
In-Reply-To: <20110224140541.GB11239@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-02-2011 11:05, Borislav Petkov escreveu:
> On Mon, Feb 21, 2011 at 09:41:46AM -0500, David Sterba wrote:
>>
>> CC: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Signed-off-by: David Sterba <dsterba@suse.cz>
>> ---
>>
>> Hi Mauro, this fix has not been applied yet, can you please pick it up?
> 
> Yeah, this looks wrong. Is this tested? Is it something you hit when
> running the driver or you've caught it with some tool/by code staring?
> 
> If it is a real problem for you, I could make an exception and send it
> to Linus next week if Mauro doesn't do it before that.

I'm a little busy those days, but I'm expecting to have some time likely
on Monday to test this patch.

Cheers,
Mauro

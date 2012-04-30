Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2D3LqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2D3LqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:46:17 -0400
Message-ID: <4F9E7B7F.1000809@redhat.com>
Date: Mon, 30 Apr 2012 08:46:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Joe Perches <joe@perches.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335535895.25521.7.camel@joe2Laptop> <4F9AC44A.5000509@redhat.com> <20120428085223.GB26065@aftab.osrc.amd.com> <4F9D4F6E.4070106@redhat.com> <4F9D5A2E.2030506@redhat.com> <4F9D6A39.6040209@redhat.com> <1335717794.12022.19.camel@joe2Laptop> <4F9D7CB8.4000903@redhat.com> <20120430074717.GB8182@aftab.osrc.amd.com> <4F9E72E0.300@redhat.com> <20120430111506.GE9303@aftab.osrc.amd.com>
In-Reply-To: <20120430111506.GE9303@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 08:15, Borislav Petkov escreveu:
> On Mon, Apr 30, 2012 at 08:09:20AM -0300, Mauro Carvalho Chehab wrote:
>>> you guys are so trigger-happy to apply humongous, cleanup patches but
>>> let me ask this: can anyone of you really test those changes with each
>>> driver? Do you have all the hardware that those patches touch?
>>
>> Well, then why you've touched that in the first place, without even looking
>> what would be affected at the EDAC core and at the drivers? Didn't you tested
>> it on all hardware that your patch affected?
> 
> Because I simply missed that fact, which is my bad, sorry.
> 
>> This patch touches only on debug code that aren't even enabled on
>> production kernels. Assuming that a sneaky bug were introduced, this
>> won't cause much hurt, and any developer inspecting those debug
>> messages will be able to discover and fix what happened there.
> 
> Ok, fine, I still will review the amd64_edac side of the changes.
> 

Ok, Thanks!
Mauro

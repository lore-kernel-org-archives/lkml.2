Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab2EJPRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:17:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759900Ab2EJPRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:17:12 -0400
Message-ID: <4FABDBE6.3060901@redhat.com>
Date: Thu, 10 May 2012 12:16:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
References: <4FAA6802.9070506@redhat.com> <20120509132237.GD22737@aftab.osrc.amd.com> <4FAA7649.5080606@redhat.com> <20120509140632.GG22737@aftab.osrc.amd.com> <4FAA7C1A.3020406@redhat.com> <20120509142456.GH22737@aftab.osrc.amd.com> <4FABBFAF.20809@redhat.com> <20120510134136.GC31257@aftab.osrc.amd.com> <4FABD653.7060401@redhat.com> <4FABD9F0.6050008@redhat.com> <20120510151254.GD32700@aftab.osrc.amd.com>
In-Reply-To: <20120510151254.GD32700@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-05-2012 12:12, Borislav Petkov escreveu:
> On Thu, May 10, 2012 at 12:08:32PM -0300, Mauro Carvalho Chehab wrote:
>> There's also another technical reason to give an acronym to the EDAC
>> version that actually works: changeset numbers are not consistent
>> within distributions (or other trees, like -stable - although this 60+
>> patch series probably won't fit on -stable merging criteria).
>>
>> Also, this EDAC changeset 60+ patch series can't be represented by a
>> single changeset, and requires userspace changes in order to get a
>> proper representation model for memories.
>>
>> Tagging the EDAC core version with a name helps a lot when dealing
>> with all the unsolved bugzillas that will be closed by backporting
>> this patch series in order to fix the serious EDAC core bug that
>> were providing fake information to the end user for all Intel memory
>> controllers manufactured after 2005.
> 
> edac_module.c:18:#define EDAC_VERSION "Ver: 2.1.0"
> 
> Increment that in the last patch.

Ok, I'll do that.

Mauro.



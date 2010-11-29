Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0K2XGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:06:11 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:58445 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0K2XGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:06:09 -0500
Message-ID: <4CF431DB.8000707@linux.vnet.ibm.com>
Date: Mon, 29 Nov 2010 21:06:03 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Jiri Kosina <jkosina@suse.cz>, Matthew Garrett <mjg@redhat.com>,
        debora@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] tpm: Autodetect itpm devices
References: <1287697360-31273-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1011291651280.28682@twin.jikos.cz> <alpine.LRH.2.00.1011300905150.26008@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1011300905150.26008@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-11-2010 20:08, James Morris escreveu:

> On Mon, 29 Nov 2010, Jiri Kosina wrote:
>>> Signed-off-by: Matthew Garrett<mjg@redhat.com>
>> 	Tested-by: Jiri Kosina<jkosina@suse.cz>
>>
>> This definitely is .37 material still, as it fixes suspend regression on
>> various machines, as reported here:
>>
>> 	http://lkml.org/lkml/2010/11/1/493
>> 	http://lkml.org/lkml/2010/11/29/219
>>
>> James, any word on this? It doesn't seem to be present either in Linus'
>> tree, nor in linux-next.
> I'm pretty sure this is the first I've seen of this, which would explain
> why it's not in my tree (Rajiv: as mainatiner please collect and forward
> TPM patches to me, or at least cc me when acking them).
>
I normally CC you when acking, don't know what happened this time, sorry.

Rajiv


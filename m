Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab0EMV3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:29:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54995 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0EMV3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:29:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Brizo+E9cfCxCli7VMYCwY3jG+UUJnS/bFVJqJpWoEEh/StRomr6WhTwNNmPMEHfb
	gVupdvja/GAnPLtLWBknQ==
MIME-Version: 1.0
In-Reply-To: <20100513203654.GA14528@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-5@gated-at.bofh.it>
	 <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop>
	 <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
	 <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
	 <20100513203654.GA14528@tango.0pointer.de>
Date: Thu, 13 May 2010 14:29:34 -0700
Message-ID: <v2u6599ad831005131429h94c8818o8aa0b805cb1bc9f1@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Paul Menage <menage@google.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 1:36 PM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
>> If you just want to track processes, mount a (named) hierarchy with no
>> attached subsystems.
>
> Oh, that is possible? How would I do that?
>
> This certainly doesn't work:
>
> # mount waldo -t cgroup /tmp/xxxx -o defaults

mount waldo -t cgroup /tmp/xxxx -o none,name=foo

Paul

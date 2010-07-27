Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0G0JN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 05:13:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0G0JNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 05:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sVspQUp0rdGadsqU5cMmWLB2evNYP9n+q4e8fJWLXH4ac1kqJT07hvAFPgLtgW4ZoK
         PUVbpmzPQxygoc7i/io9GSi3RzRKrZ9k+wFyeXK+qyX3f96L59muDV7S9hbDlXUJGOA3
         SXr7z8zVZe9V63JD1bMg9KO13nFbO+uNkwonw=
MIME-Version: 1.0
In-Reply-To: <20100726152315.GA18789@hmsreliant.think-freely.org>
References: <20100713134609.GA14514@hmsreliant.think-freely.org>
	<20100726152315.GA18789@hmsreliant.think-freely.org>
Date: Tue, 27 Jul 2010 17:13:24 +0800
Message-ID: <AANLkTimx4=y4DgreWJOQ2=y4CmMm1p7bku=UJtsXXss3@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Add vmcoreinfo symbols to allow makdumpfile to 
	filter core files properly
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
        hbabu@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:23 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Jul 13, 2010 at 09:46:09AM -0400, Neil Horman wrote:
>> Hey all-
>>       About 2 years ago now, I sent this patch upstream to allow makedumpfile
>> to properly filter cores on ppc64:
>> http://www.mail-archive.com/kexec@lists.infradead.org/msg02426.html
>> It got acks from the kexec folks so I pulled it into RHEL, but I never checked
>> back here to make sure it ever made it in, which apparently it didn't.  It still
>> needs to be included, so I'm reposting it here, making sure to copy all the ppc
>> folks this time.  I've retested it on the latest linus kernel and it works fine,
>> allowing makedumpfile to find all the symbols it needs to properly strip a
>> vmcore on ppc64.
>>
>> Neil
>>
>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>>
> Ping, anyone want to chime in on this, its needed for dump filtering to work
> properly on ppc64

This patch looks good for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1C3XsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:48:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab1C3XsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gwJms+pjxFRjyMmphJeiktHKVH+6ZnmihmgLw48gY7FjszYKNEtTPzrrRyCLiFDfHo
         cHLDKVul42rkVPXj18ZA==
MIME-Version: 1.0
In-Reply-To: <20110330234413.GI21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
	<20110330210751.A9ADB3E1A05@tassilo.jf.intel.com>
	<20110330213338.GA20367@redhat.com>
	<20110330234413.GI21838@one.firstfloor.org>
Date: Wed, 30 Mar 2011 16:48:10 -0700
Message-ID: <BANLkTimjdxx87f3wmFFNUfCuoPSw-zw6nA@mail.gmail.com>
Subject: Re: [PATCH] [226/275] Prevent rt_sigqueueinfo and rt_tgsigqueueinfo
 from spoofing the signal code
From: Julien Tinnes <jln@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com,
        Roland Dreier <roland@purestorage.com>, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 4:44 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> If stable needs this change, then it probably needs
>>
>>       Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
>>       commit 243b422af9ea9af4ead07a8ad54c90d4f9b6081a
>>
>> as well.
>
> Added thanks.
>
> BTW I think Greg would need that too for .32.

He has it already I think (thanks to Oleg).

Julien

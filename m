Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0LMJVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:21:10 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:39894 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0LMJVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:21:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q6g3ZzXxPtqsZZdUHiXi+0uFMj9xRn8LZKYiRR0uIISaT+AQ+yUOS5jFVP0YWOU7dH
         sIJcDqfdqRgnfkqWAUi73m0F8w1g8iVvW8VLjM1jg9fxXjhRmMdjK9F4aax5KRgbL5xU
         s6yXknCXS4za60P2rXXruqCJU3ruSBXGbJkV0=
MIME-Version: 1.0
In-Reply-To: <4D05E518.6040906@redhat.com>
References: <201012131244.547034648@firstfloor.org> <20101212234644.B05DAB27BF@basil.firstfloor.org>
 <4D05DC98.40105@redhat.com> <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
 <4D05E096.6060307@redhat.com> <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
 <4D05E2A5.8070204@redhat.com> <AANLkTikcYAaxrdRR_i3p5o2tegEVM=0ajuihwu+C5eoK@mail.gmail.com>
 <4D05E518.6040906@redhat.com>
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Date: Mon, 13 Dec 2010 10:20:46 +0100
Message-ID: <AANLkTikx=wygwhq2i0rBFEebJOoGWSQyazHKR=923mgE@mail.gmail.com>
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:19 AM, Avi Kivity <avi@redhat.com> wrote:
>> But all the patches tagged for -stable are supposed to be already
>> upstream and therefore well tested.
>> What am I missing?
>
> They were tested upstream on the upstream code base.  That says nothing
> about 2.6.35 (well, it says something, but not as much as "2.6.35 with the
> patch managed to install and run various tests with several Linux and
> Windows guests, and did not cause regressions in the unit test suite").

Sure, makes lot of sense. Thanks for the clarification.

Regards,
-- 
Paolo

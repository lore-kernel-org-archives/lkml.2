Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1FCSHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:07:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47899 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1FCSHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Fuz99399mg4QEWSOvEHRUZfIPLHFd0Lr0C+Sd74qrf2eNTPR2IgWskkQVMHqm2D1pV
         Np7qvpdeZKag3fvkkRcZeqAPKpdJYm56iXxwSzDe1buwJbsf5MGKsqNQtVWm6dA48hYd
         VJlym4JGnpMgAxF2rVLYM3sTlMSQWWQaAX/AQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106030941100.27151@router.home>
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com>
	<alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com>
	<4DE7D2AC.1070503@tilera.com>
	<BANLkTinjCbhiwRfQ_aN5wtbYipQB6gv5AA@mail.gmail.com>
	<alpine.DEB.2.00.1106030905590.27151@router.home>
	<4DE8F0D4.2090008@tilera.com>
	<alpine.DEB.2.00.1106030941100.27151@router.home>
Date: Fri, 3 Jun 2011 21:06:59 +0300
X-Google-Sender-Auth: _zc0AqhVGdJAg2a6hLpBrN2TDbU
Message-ID: <BANLkTi=10tZjXW7WNxJiPmQit+wW1AZEuQ@mail.gmail.com>
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double requirement
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 5:41 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 3 Jun 2011, Chris Metcalf wrote:
>
>> On 6/3/2011 10:06 AM, Christoph Lameter wrote:
>> > On Fri, 3 Jun 2011, Pekka Enberg wrote:
>> >
>> >> On Thu, Jun 2, 2011 at 9:13 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> >> > On 6/2/2011 1:16 PM, David Rientjes wrote:
>> >> >> Acked-by: David Rientjes <rientjes@google.com>
>> >> Yup. Looks good. Christoph?
>> > Ok if we do not mind the packing density to be not that tight anymore.
>> >
>> > Acked-by: Christoph Lameter <cl@linux.com>
>>
>> I'm assuming from the acks that I should ask Linus to pull this for 3.0
>> along with a couple of other minor tile-specific changes.  However, please
>> let me know if someone else would rather take it into their tree instead --
>> I don't want to step on any toes.  Thanks!
>
> I would expect the patch to go through Pekka's tree to Linus.

Applied, thanks!

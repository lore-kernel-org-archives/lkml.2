Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1J1Roe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:44:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1J1Rod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:44:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QXL5DtMwEASIvJMJq8SiwME7S8Jde4KCA2xdfY2GxPgiZF3Fxcgu5jjziKemk5NnL
	pvzyEnHKZ1pjD6+aFpnHw==
MIME-Version: 1.0
In-Reply-To: <201110272235.59240.rjw@sisk.pl>
References: <CAErSpo4REhcp_SgDyUTbi8jw9_8317Zi1duo1fTihB8x=drtuw@mail.gmail.com>
 <201110262013.55562.maciej.rutecki@gmail.com> <201110272235.59240.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 28 Oct 2011 11:44:09 -0600
Message-ID: <CAErSpo7ck7N780SfF6NnCFK97PUJc2sx5742kzspq5DbDHkJqQ@mail.gmail.com>
Subject: Re: regression tracking
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: maciej.rutecki@gmail.com, Florian Mickler <florian@mickler.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 2:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, October 26, 2011, Maciej Rutecki wrote:
>> Hi
>>
>> On środa, 26 października 2011 o 19:23:11 Bjorn Helgaas wrote:
>> > The regression tracking that you folks used to do before the demise of
>> > bugzilla.kernel.org was incredibly valuable.
>> >
>> > I'm very concerned about the fact that we don't have a systematic way
>> > to do this any more.  Some things do get reported on LKML, of course,
>> > but without the legwork you guys did, I'm afraid we're just dropping
>> > things on the floor because there's no summary of what the issues are,
>> > how many people are seeing them, who's responsible, etc.
>> >
>> > Consider this as (1) kudos for performing an essential community
>> > service, and (2) a plea for the resurrection or replacement of
>> > bugzilla.kernel.org or some other mechanism for reviving regression
>> > tracking.
>>
>> Because bugzilla is still down, I yesterday started send regressions (found in
>> LKML) report directly to Rafael, to create summary report (etc.) of them.
>> Until bugzilla comes back, we plan to collect regression in this way, but any
>> proposal for a better solution is welcome.
>
> Seconded.
>
> Especially if there's a password-protected Wiki service somewhere that we
> could use to store data temporarily until the BZ is back, it would be much
> appreciated.

I don't know exactly what you would like to do with a wiki, but Google
Docs might be a possibility.

Disclaimer: I work for Google but this is not any sort of official
offer of help or support beyond the standard functionality that's
available to everybody.

Bjorn

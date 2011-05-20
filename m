Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1ETQp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:45:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4899 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1ETQp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x/3i7iykw/APsaNKDVkNJ0T17IlA6HU+phM1+SiPjtSi/OMLAIqcZgYBJOJxBgFQl3
         /veUCnEFKU1JHZFXuQwg==
MIME-Version: 1.0
In-Reply-To: <1305903917.2466.7237.camel@twins>
References: <20110520143716.GA5381@quad>
	<1305903917.2466.7237.camel@twins>
Date: Fri, 20 May 2011 18:45:44 +0200
Message-ID: <BANLkTimZhpfgKoEki16r5zabNCrvK-GsUw@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an extra
 reg (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 5:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-05-20 at 16:37 +0200, Stephane Eranian wrote:
>> The is_fake field is necessary to avoid a lockdep issue having
>> to do with interrupt masking and era->lock.
>
> Why not simply disable IRQs in both validate_* functions?
>
Could do that too if you think that's cleaner.

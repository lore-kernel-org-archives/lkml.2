Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784Ab0HLV3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:29:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735Ab0HLV3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:29:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uwijGc7430fU/7kh8JWiSXne3kcFgKwlnYynWEvoxXPnGg4qBYyaJvA5i3/4lB3iJ
	X8w1l/nG/sXdJ63nmVU0w==
MIME-Version: 1.0
In-Reply-To: <20100812182000.GD21829@ghostprotocols.net>
References: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
	<20100812182000.GD21829@ghostprotocols.net>
Date: Thu, 12 Aug 2010 23:29:09 +0200
Message-ID: <AANLkTimNZa-HR7bquzNRc9igLajJjTmveJ+XReCgbKJZ@mail.gmail.com>
Subject: Re: [PATCH] perf trace: get rid of the hard-coded paths in the report scripts
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 8:20 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Thu, Aug 12, 2010 at 12:59:18PM -0500, Tom Zanussi escreveu:
>> The perf trace report shell scripts hard-code the exec path of the
>> scripts into their command-lines, which doesn't work if perf has been
>> installed somewhere else.
>>
>> Instead, perf trace should create the paths at run-time.  This patch
>> does that and removes the hard-coded paths from all the report scripts.
>>
>> v2 changes: The first version inadvertantly caused scripts run from
>> outside the perf exec path to fail e.g. 'perf trace -s test.py'.  The
>> fix is to try the script name without the exec path first, then the
>> version using the exec path, which restores the expected behavior.
>>
>> Reported-by: Stephane Eranian <eranian@google.com>
>> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
>
> Stephane,
>
>        Lemme know when you tried this patch so that I can merge it with
> a Tested-by: you tag, ok?
>
Will get back to you tomorrow morning (your time).

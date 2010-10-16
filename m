Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0JPSkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 14:40:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60976 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0JPSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 14:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GGlB7vpVeJWhrMhl6xJx9V3ZNcS6QNn40H8PPf17bRmW/Vki+lTNGNCg6YJKpVr0oc
         hhiuK7KnttbsiJZBd17/n7AvZZEJVqsg6czUTUZ8IDv/U/ag1ZnJehcIqRSSvcsF6mi8
         D+3db2PS7+7CccyYqTtpP1LLyMpg7elRSOmWo=
MIME-Version: 1.0
In-Reply-To: <20101016182037.GA26090@elte.hu>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
	<tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
	<1287250157.1998.124.camel@laptop>
	<20101016182037.GA26090@elte.hu>
Date: Sat, 16 Oct 2010 21:40:50 +0300
Message-ID: <AANLkTimGLSNRcYxY3G41xHAa=0q1jmdL-peP-a0knzV9@mail.gmail.com>
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        ying.huang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        dzickus@redhat.com, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> NACK!
>>
>> I object to the DIE_NMI_IPI existance..
>
> Ok - i've zapped the commits for the time being.

Hi, Peter.

If you have any ideas how things can be better, I want to see them.
Some code please.

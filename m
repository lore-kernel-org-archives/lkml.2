Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1EJNnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:43:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57945 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab1EJNnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QTF/RJek//EGDxk12N8vnILrPWWZyTtlahLo46ungQXK7oXgue/AadX0wIHcT30ZnS
         EhuKQ5PV51cmMFb5NHy8ImruNver+7aX/w8DRWHdxYpXCe0zNXI7RDxNer9nVO8m1NJs
         17ALMjvuSyZHE+OCZHedmAPPw43IEcEHSce0w=
MIME-Version: 1.0
In-Reply-To: <1304136894.3761.1.camel@localhost>
References: <1304066518-30420-1-git-send-email-ming.m.lin@intel.com>
	<1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
	<20110429173332.GA3273@ghostprotocols.net>
	<1304136894.3761.1.camel@localhost>
Date: Tue, 10 May 2011 21:43:22 +0800
Message-ID: <BANLkTikCXsyppqeew=7o-8fxZpytevpFsw@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/2] perf probe: Fix the missed parameter initialization
From: Lin Ming <minggr@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 12:14 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Sat, 2011-04-30 at 01:33 +0800, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Apr 29, 2011 at 08:41:57AM +0000, Lin Ming escreveu:
>> > pubname_callback_param::found should be initialized to 0 in fastpath lookup.
>>
>>
>> Is this really needed? Or is this just to stress it, for documentational
>> purposes?
>
> Yes, this is really needed.
>
> It should be initialized to 0, and pubname_search_cb will set it to 1 if
> the function is found.

ping ...

-- 
Lin Ming -- Intel Open Source Technology Center

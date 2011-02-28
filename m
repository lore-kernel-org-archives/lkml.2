Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1B1Viw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:38:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42990 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1B1Viv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:38:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tKQ4w4zsUq9JbYLDMxHhfwM1PuD+zuytdKATWmLH5xKeWg/pI3geckaSUl8ie+cqeu
         65VN2olOfKLiV7wLVv9A==
MIME-Version: 1.0
In-Reply-To: <20110228122236.GA1211@merkur.ravnborg.org>
References: <1298506377-16796-1-git-send-email-mikew@google.com>
 <201102272107.48934.arnd@arndb.de> <AANLkTikijjZwQp6Fer9TqRqQe=2WhSCPcDv5mczcGD8g@mail.gmail.com>
 <201102281311.16811.arnd@arndb.de> <20110228122236.GA1211@merkur.ravnborg.org>
From: Mike Waychison <mikew@google.com>
Date: Mon, 28 Feb 2011 13:38:28 -0800
Message-ID: <AANLkTi=pY4-c6W8O1+OG1Fpe-7y20E6eiwt3yzA0EwQq@mail.gmail.com>
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 4:22 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Feb 28, 2011 at 01:11:16PM +0100, Arnd Bergmann wrote:
>> On Monday 28 February 2011, Mike Waychison wrote:
>> > How is one expected to test if the files should be rebuild or not?
>> > Forcing a headers_install as part of a build will cause the entire
>> > userland to be rebuilt.
>>
>> How about changing headers_install to only install files that have
>> changed? Make headers_install alreadh knows the list of all files
>> it is installing.
>
> make headers_install already does so. Only changes fiels are updated.
> So I consider this a non-issue.

Aha, I missed this point.  I've updated our build to do a
headers_install and things seem to work fine.

Thanks for the pointers :)  Please forget about this patch.

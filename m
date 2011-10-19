Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1JSXQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:16:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54371 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1JSXQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:16:37 -0400
Message-ID: <4E9F5A3E.7050408@zytor.com>
Date: Wed, 19 Oct 2011 16:16:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Andi Kleen <andi@firstfloor.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?UTF-8?B?UGx1bWJlcuKAmXMgV2lzaCBMaXN0IGZvciBMaW51eA==?=
References: <1317943022.1095.25.camel@mop> <m2lisx3cpl.fsf@firstfloor.org> <20111007001356.GA11994@tango.0pointer.de>
In-Reply-To: <20111007001356.GA11994@tango.0pointer.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 05:13 PM, Lennart Poettering wrote:
> 
> Well, I am aware of PR_SET_NAME, but that modifies comm, not argv[]. And
> while "top" indeed shows the former, "ps" shows the latter. We are looking
> for a way to nice way to modify argv[] without having to reuse space
> from environ[] like most current Linux implementations of
> setproctitle() do.
> 
> A while back there were patches for PR_SET_PROCTITLE_AREA floating
> around. We'd like to see something like that merged one day.
> 

A saner thing would be if the initial argv[] area couldn't be modified
at all, and that an explicit system call was required to change the
title displayed by ps or top, but that ps or top could be forced to show
the argv as initially passed to the process.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1B0XzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:55:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:23309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1B0XzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gjouWUsKteMsOz2219Mc3t8v+Mckg8V2GYKmPCxm2grb1pe3ZaqJiXr8dPTUWMTU7R
         InNBXETpDGji3CPYNXCw==
MIME-Version: 1.0
In-Reply-To: <201102272107.48934.arnd@arndb.de>
References: <1298506377-16796-1-git-send-email-mikew@google.com>
 <AANLkTi=8S4=vEUNHR6zD8d1or6BS_o9k4nPg4he+Kik2@mail.gmail.com>
 <20110226222255.GB24028@merkur.ravnborg.org> <201102272107.48934.arnd@arndb.de>
From: Mike Waychison <mikew@google.com>
Date: Sun, 27 Feb 2011 15:54:47 -0800
Message-ID: <AANLkTikijjZwQp6Fer9TqRqQe=2WhSCPcDv5mczcGD8g@mail.gmail.com>
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
To: Arnd Bergmann <arnd@arndb.de>
Cc: klibc@zytor.com, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 12:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 26 February 2011, Sam Ravnborg wrote:
>> >
>> > What you are proposing seems to me like a step towards giving up on
>> > this noble goal :(
>> You seem to be confusing something here. Even if klibc is one day
>> included in the kernel source then we should continue to use
>> the headers generated using "make headers_install" for building klibc.
>
> Absolutely, yes.
>
> Mike, just think of the generated header files as intermediate files
> required for building, just like the .o files that are use to build
> the library.

How is one expected to test if the files should be rebuild or not?
Forcing a headers_install as part of a build will cause the entire
userland to be rebuilt.

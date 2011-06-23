Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461Ab1FWUny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:43:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925Ab1FWUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=E7AQM4qZZ10copJ08uhWVXJJDG+zXKC5G8hkE+u1Ywp6wC2RlklKw2xBYdeV0YpR8U
         eqHJZw53j3Xg2lOXatRw==
MIME-Version: 1.0
In-Reply-To: <62229.1308859172@turing-police.cc.vt.edu>
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
	<62229.1308859172@turing-police.cc.vt.edu>
Date: Thu, 23 Jun 2011 13:43:49 -0700
X-Google-Sender-Auth: 0eg4JIZUCKLnQ1lrqN7d_Ry6wF0
Message-ID: <BANLkTiko9PvSDHEnbjCAvcAReLytWwg7qSoZGv778xuj3tqW=g@mail.gmail.com>
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
From: Sergiu Iordache <sergiu@chromium.org>
To: Valdis.Kletnieks@vt.edu
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 12:59 PM, <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 23 Jun 2011 11:36:00 PDT, Sergiu Iordache said:
> > Ramoops currently has module parameters for setting the configuration
> > variables (ram start, ram size and dump oopses). This makes it difficult to
> > configure when the module is compiled as a builtin.
>
> Can't you add 'ramoops.ram_start=128M ramoops.ram_size=64M' or similar
> to your kernel cmdline?

You can but the problem is that when you're using the module as a
builtin managing the command line is harder than managing Kconfig
files. Instead of having different platform dependent config files
(which already exist in most of the cases) under source control you
would have to have different scripts which run the kernel with
different parameters.

Sergiu

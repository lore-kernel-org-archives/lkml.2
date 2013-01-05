Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3AEMAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 07:00:24 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:39169 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3AEMAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 07:00:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121227044315.GA17472@x1.alien8.de>
References: <20121225223045.GA23445@liondog.tnic>
	<CAJd=RBBsJBnDyfC5QUtRwnMFBXATrhxT9t0heNRpNv5DEqe4Fg@mail.gmail.com>
	<20121227044315.GA17472@x1.alien8.de>
Date: Sat, 5 Jan 2013 20:00:19 +0800
Message-ID: <CAJd=RBD_merz-7zBJohqHtSkgMWUcBFVn=6RzDNzJBkFwkRNZQ@mail.gmail.com>
Subject: Re: kvm lockdep splat with 3.8-rc1+
From: Hillf Danton <dhillf@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Hillf Danton <dhillf@gmail.com>,
        kvm list <kvm@vger.kernel.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav

On Thu, Dec 27, 2012 at 12:43 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Dec 26, 2012 at 08:18:13PM +0800, Hillf Danton wrote:
>> Can you please test with 5a505085f0 and 4fc3f1d66b reverted?
>
> sure can do, but am travelling ATM so I'll run it with the reverted
> commits when I get back next week.
>
Jiri posted similar locking issue at
        https://lkml.org/lkml/2013/1/4/380

Take a look?

Hillf

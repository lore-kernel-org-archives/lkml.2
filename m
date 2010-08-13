Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab0HMKnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:43:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53671 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761456Ab0HMKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=fqVbftyzpltp/qMy0jGDvOrYS/hDBJ2LtPz3V/yMDEeb+blZMvD4S2pR/3nDtLfbuk
         3irvhFFCDYbg+fjLr1mwdx36aOVQPN+ip56Glt1eDvjdkRXua55cOMkBujSo35lLnDQv
         og1NMyGtTOj/jnAlo6Q7smw6gcQPyAAMqDG6Q=
MIME-Version: 1.0
In-Reply-To: <20100812195224.GA6370@comet.dominikbrodowski.net>
References: <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812174303.GD2524@linux.vnet.ibm.com>
	<AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	<AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
	<20100812195224.GA6370@comet.dominikbrodowski.net>
Date: Fri, 13 Aug 2010 13:43:08 +0300
Message-ID: <AANLkTimCrOqizJ7LL7t3hN=wMF_oxNFPxKbjWz_AsZ_U@mail.gmail.com>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
        galibert@pobox.com, florian@mickler.org, menage@google.com,
        swmike@swm.pp.se, linux-pm@lists.linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 10:52 PM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> On Thu, Aug 12, 2010 at 12:48:48PM -0700, Brian Swetland wrote:
>> I guess I don't understand,
>
> I guess I don't, either -- there are some parts of the kernel used by only a
> handful of users... and here we speak about million users...

A driver that sits in a corner and doesn't show in the 'menuconfig' of
most people and is used by small fraction of user-space applications
(perhaps even 0) is just fine. But we are talking of something
centric, that can be enabled on all systems, and that affects all
user-space.

-- 
Felipe Contreras

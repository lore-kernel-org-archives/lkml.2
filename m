Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0HHMkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:40:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51272 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0HHMk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=he8R0KQgEHDFAtaz1vd4PjoTe9LOEDroiP/poA5W9Y6BCWUsqmCPrAliFspnqI+4tn
         ujoE7wmr/Lx4bE4oqxhtoJC5Iwqa19uoHusqqV1M3S1NYDVggpEzlWXKG67QiiSvztjZ
         bI5CgyHcwkSpU4wo4HtEUM9bvcJNAynaFS+7w=
MIME-Version: 1.0
In-Reply-To: <20100806225453.GA3947@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
Date: Sun, 8 Aug 2010 15:40:28 +0300
Message-ID: <AANLkTik3qF2yScLJiDBWLN5=Ez0FsvbOo0M76WbOAGvO@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, david@lang.hm, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, tytso@mit.edu,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 1:54 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> o       "Ill-behaved application" AKA "untrusted application" AKA
>        "crappy application".

> o       "PM-driving application" are applications that are permitted
>        to acquire suspend blockers on Android.

These definitions are wrong.

1) There are trusted applications that misbehave (the user clicks Yes
when asked about PM permissions)
2) There are untrusted applications that are power optimized (The user
clicks No)

The proponents of suspend blockers in user-space have tried to ignore
this fact, but the truth is that PM permissions and power optimization
are orthogonal to each other.

-- 
Felipe Contreras

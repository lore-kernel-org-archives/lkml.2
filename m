Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab0J0XKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:10:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37586 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0J0XKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=uz7rjY0MMw+uHtqbvaY/jCrDRZMfvRTdz3qZWbwK5kbquOPsQ+035Exe9faii2qHyp
         e8A1xUvif10n9Oh/llhUcXXrxcjQR/TMALh3p2mBOBwmOz1B1CDpIEjFbaoA1Kdd6W0N
         hs4Tw5pFijN4eGkcRP4U4anUDHOm4Mt0SBgI4=
MIME-Version: 1.0
In-Reply-To: <4CC8ABC7.5030003@suse.cz>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com> <4CC8ABC7.5030003@suse.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 27 Oct 2010 19:10:09 -0400
Message-ID: <AANLkTimCoH1YA3sh3W_59QG42CwtRXQovgqUw2SndUO6@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Michal Marek <mmarek@suse.cz>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 18:46, Michal Marek wrote:
> On 27.10.2010 20:23, Mike Frysinger wrote:
>> can we get this change dropped from linux-next until someone gets a
>> chance to fix it ?
>
> Sorry I missed this thread. So your last patch
> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
> failure? Can you submit it with a proper Signed-off-by and changelog?

it shouldnt be a sep change.  it should be squashed into the broken
one so that the result works.
-mike

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0CSAek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:34:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58638 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0CSAei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=F1vAKiZ0NxEWLgh4MP4M6olmgpnhE5RFsIgh45ccPNmS5sJppGPxMmd+040AYx/Ohc
         vBkwxkmN+B1/cwuPC/4AkNKGVybDSuHsHlofJkChnJyZ1Ri+tScmrYPGrQyi3jGLWynx
         H3seTutJmISkirNfkCRxDgY7xGbJftL35ebG8=
MIME-Version: 1.0
In-Reply-To: <20100318235134.GP5454@kroah.com>
References: <1267814404-27394-1-git-send-email-lrodriguez@atheros.com> 
	<20100318235134.GP5454@kroah.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Mar 2010 17:34:18 -0700
X-Google-Sender-Auth: c4bc5bab83aaaf69
Message-ID: <43e72e891003181734g1356d1b6t6fccf2c1ea8afded@mail.gmail.com>
Subject: Re: [stable] [PATCH 2.6.23..2.6.24] Backport r and q constraints 
	fixes
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stephen.chen@atheros.com,
       cliff.holden@atheros.com, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 4:51 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Mar 05, 2010 at 01:40:04PM -0500, Luis R. Rodriguez wrote:
>> Upstream commit: 811a0fff5d6e80e18e06be88e0fb685f3924bf8f
>>
>> This patch included on 2.6.25 is required to be backported to compile
>> both the 2.6.23 and 2.6.24 kernels on x86_64 systems with a modern
>> toolchain. Otherwise you get this pesky assembly error:
>
> You do realize that the .23 and .24 kernels are no longer supported,
> right?

Heh yes, but figured the google cache will still support those users.

  Luis

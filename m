Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1CBMGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:06:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53778 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1CBMGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=i7Grh5bRJmEBC+S1cqlZej826nWMQZU9iR8KB7qoHfZbe+Cro3O2yCx/9PnftuSxFA
         KdZdprs2F99dITAaVQ0Bx5bY2V4oatSyzsf3LUEWI/fRdTE1d4VW0eOX2P7HC9Fq2e+E
         Fl1HAs2PqX48yCweXV5nEuKJJC6avGeZ24Suw=
MIME-Version: 1.0
In-Reply-To: <4D6E2C9C.1060404@linux.vnet.ibm.com>
References: <4D6E2C9C.1060404@linux.vnet.ibm.com>
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Date: Wed, 2 Mar 2011 13:06:19 +0100
Message-ID: <AANLkTikTM7wv0ogVPueLjK391sqaUyekquMXBea0ayFc@mail.gmail.com>
Subject: Re: [ANNOUNCE] The Linux Test Project has been released for FEBRUARY 2011.
To: Shubham Goyal <shubham@linux.vnet.ibm.com>
Cc: ltp-list@lists.sf.net, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        yanegomi@gmail.com, vapier@gentoo.org, subrata@linux.vnet.ibm.com,
        chrubis@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 12:40 PM, Shubham Goyal
<shubham@linux.vnet.ibm.com> wrote:
> Hi,
>
> The Linux Test Project test suite has been released for the month of
> FEBRUARY 2011. Please see ltp/INSTALL file carefully, as there has
> been multiple changes for building/installing the test suite after the
> recent changes in Makefile infrastructure.

Wouldn't make sense to integrate this test suite in the kernel source tree?

Regards,
       Paolo

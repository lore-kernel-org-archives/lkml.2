Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0KVWhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 17:37:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64359 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0KVWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 17:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xxX20Nt2d3SoBcna/aCMndZvl8Xdf5wX9A78PQNZsI6vmTX5J5uiG7YmOUJwv9bGjI
         BcRF7D/NEYKm2bnm+97gcrhVyNFhoAovZFUZGR+Q40lPk44lO8lz6hOGAsRWYvwFZYNh
         D+fLN4zbSqBlFs1bdrOPVJ7UEv1KNkQTyj6C8=
MIME-Version: 1.0
In-Reply-To: <20101122183554.764aa480@neptune.home>
References: <AANLkTikt2k8jC4ykYqYG_hQPAZt0-GXAvD1DPogu+AB0@mail.gmail.com>
	<20101122183554.764aa480@neptune.home>
Date: Mon, 22 Nov 2010 15:37:43 -0700
Message-ID: <AANLkTi=XDgRUBkZrCmy0=hqsntyWz4HqbozELFR+EAFd@mail.gmail.com>
Subject: Re: Best place to ask this question: error with compiler.h when
 switching from 2.6.32 to 2.6.36
From: Derek Nielson <dereknielson@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The error alone won't help too much as probably it's happening more or
> less deep inside macros, thus the whole parameters to the macro are
> required to understand.

You were right the error message wasn't really the problem there was
something wrong inside the macro.  The error message threw me off.
Thanks for your help, the module is compiling now against the kernel.

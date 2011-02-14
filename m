Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1BNUpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:45:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49700 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1BNUps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:45:48 -0500
MIME-Version: 1.0
In-Reply-To: <1297133758.2323.5.camel@localhost.localdomain>
References: <1294266337.3237.45.camel@localhost.localdomain>
	<201101270942.07689.sgrubb@redhat.com>
	<20110128184901.GA5134@localhost>
	<201101281410.29794.sgrubb@redhat.com>
	<20110128193809.GB8854@localhost>
	<1296584221.3145.12.camel@localhost.localdomain>
	<20110201212605.GB5294@localhost>
	<AANLkTin6Msom+b8wHULvzEjA+VL5ofQ9wx-ZN5SiK6-p@mail.gmail.com>
	<1297133758.2323.5.camel@localhost.localdomain>
Date: Mon, 14 Feb 2011 15:45:46 -0500
Message-ID: <AANLkTin701rA70UzDYK21nSmUAYz62Xg=-Rtxg8nebWw@mail.gmail.com>
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@parisplace.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Steve Grubb <sgrubb@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 9:55 PM, Eric Paris <eparis@redhat.com> wrote:
>
> Below is what I'm working on.  I've asked dhowells to review the creds
> code, since commit_creds() does not take const.  Maybe that's just an
> oversight.  Basically I've exposed two new sysctls.
>
> /proc/sys/kernel/usermodehelper/bset
> /proc/sys/kernel/usermodehelper/inheritable
>
> You must have CAP_SYS_MODULE to change these (changes are &= ONLY).
> When the kernel launches a usermodehelper it will do so with these as
> the bset and pI.  I haven't attempted securebits and uid (since I didn't
> really need them I don't think)  But will if anyone can think of a use
> case.
>
> Is this what you were thinking?


Anything?  Problems with this patch/approach?

-Eric

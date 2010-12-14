Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab0LNRAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:00:03 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:33750 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759558Ab0LNRAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Kw06lZ/bVI6+4HDPjnX42XMPmPm/smvydxuTb5nEMVwkS5nkIPB4FEA9j0kc7kwMaN
         N48D8MwEhxdYZj4FlGv/jHppi5Hu11Aq0iUPO0OQB1snqdXdboEergF8VJwNxVqW9dCV
         wSRkCrVeMD8iF1fSMr6HiYtUb71r03SkmM6Ys=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=NKa6UCeYsE0Y5iWnq8XYbVtSU7XiKJSNc5tLz@mail.gmail.com>
References: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>
	<987664A83D2D224EAE907B061CE93D530193BBAA27@orsmsx505.amr.corp.intel.com>
	<AANLkTi=NKa6UCeYsE0Y5iWnq8XYbVtSU7XiKJSNc5tLz@mail.gmail.com>
Date: Tue, 14 Dec 2010 09:00:00 -0800
Message-ID: <AANLkTin98z8_Maa8iJfbzyjtRDLkTve7PShPAvdukqZd@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
From: Tony Luck <tony.luck@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:35 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> I saw (very quickly) in drivers/staging/dream/pmem.c

Most recent commit for that says:

    Staging: dream: remove dream driver and arch from tree

    This code is stalled, with no one working on it anymore, and the main
    msm code is now going through the proper channels to get merged
    correctly.

    So remove it as it contains a number of kernel information leaks and it
    is doubtful if it even still builds anymore.

:-(

-Tony

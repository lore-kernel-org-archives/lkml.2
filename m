Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0CZAwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:52:13 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45509 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0CZAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N2CnVV3zOu1LAey3ubz6ZEC+5fnTmsjRZbGDsRO43e5UJJNgYy+SBf3+yiW+bP/v7L
         z33Oyz0jWhYytrzQbJ32pUx9oMbTnrzjZ2kY1I/MPo3RTYOOEWHSFanmE12urIoa/le1
         HmPMOBgrX7PnxDwTVjqw/BfrYQJ5Qlp6OJXno=
MIME-Version: 1.0
In-Reply-To: <4BAB3C0D.4080906@trash.net>
References: <20100325092154.GB29056@localhost.localdomain>
	 <4BAB3C0D.4080906@trash.net>
Date: Fri, 26 Mar 2010 08:52:09 +0800
Message-ID: <628d1651003251752v3d49b8acs6b43d76b2477b8a3@mail.gmail.com>
Subject: Re: [PATCH] Netfilter: Code cleanup on net/netfilter
From: wzt wzt <wzt.wzt@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, thx, i'll send a new patch soon.

On Thu, Mar 25, 2010 at 6:33 PM, Patrick McHardy <kaber@trash.net> wrote:
> wzt.wzt@gmail.com wrote:
>> Fix some coding styles and remove moduleparam.h
>
> I've already applied your patches to remove moduleparam.h.
> Please base your patches on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
>

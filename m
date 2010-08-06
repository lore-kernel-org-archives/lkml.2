Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab0HFQlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:41:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36192 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab0HFQlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Wn7pCYAz1qZed7fx3yQy129yIVGQJtuy6VVz6dwezaoYsEK9G/Ne341YjirW98nUb+
         Fhd0v/FsbZbA0471VgJuxk2UGoE/+ppUVOjZi/kfKoTT4Ukx+e5vrERD6LhljjZMlRvM
         byVRXUvI2bfcb5yXR/B8I35WOkLt3JtlG+3BI=
MIME-Version: 1.0
In-Reply-To: <1281112206-31808-1-git-send-email-vapier@gentoo.org>
References: <1281112206-31808-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 6 Aug 2010 12:40:55 -0400
Message-ID: <AANLkTimxy7sJP3VM_O9VUhdyeW7=GPcE6wKwgF2+csFW@mail.gmail.com>
Subject: Re: Blackfin updates for 2.6.36-rc0
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 12:30, Mike Frysinger wrote:
> Blackfin: switch to asm-generic/io.h
>  include/asm-generic/io.h                           |   56 +++++

ugh, that change is half baked.  thought i had split that stuff
already, but guess not.
-mike

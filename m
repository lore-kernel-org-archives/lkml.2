Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab0JZK4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:56:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54355 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab0JZK42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RFHuXJ6xTRFItwB1MdCK19vMRqbU2+5vQAyoCrczQFpIB3drpX+u1WlE56KptpmQH7
         /jQ731hzVc2AKrXfyd5JBpy5T+Fk7aiIIsy7tGBKAwcqn34Kg5c3tQ/7rtqaHQ6mEyq4
         jcb3kVlLHKKdr1pnLSW57milLk4uTuNN8vyoU=
MIME-Version: 1.0
In-Reply-To: <4CC3F13B.4030107@gmail.com>
References: <4CC3F13B.4030107@gmail.com>
Date: Tue, 26 Oct 2010 12:56:28 +0200
Message-ID: <AANLkTim460pm6QNgUh+C0p=D3Ppu7Q3Dx1j2PNd7Amdr@mail.gmail.com>
Subject: Re: [PATCH] archs: add ioremap_change_write_prot
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Tim Bird <tim.bird@am.sony.com>, andi@firstfloor.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/24 Marco Stornelli <marco.stornelli@gmail.com>:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> This patch adds a new function called ioremap_change_write_prot.
> Goal of this patch is to create a general function for all archs to be
> able to change a write protection of a memory mapped area. x86
> has already got a similar framework, so this function is only
> a wrapper. Next target will be arm and powerpc. This function
> will be used by Pramfs (see its latest review).
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Sorry to re-open the topic, but I'd like to receive any
comments/feedback about this patch.

Marco

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1CVVSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:18:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45876 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1CVVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=LzfVRwhuN4+HflhwCsOMC+J8f7CwTeURbnoPKwjfE1yuXXVkA/GqP1VX/ktibdBQgH
         ddDTIoMxuhN90Htf0qiiDwwdyICOiwZZ7n8f4MUzX9EQCW+FO035EU60nHR5sK21V+a4
         Fq/Xiv1ZZ1FIJKV5BaBIg2n7GWB0erxd8KVXE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103221601010.16870@router.home>
References: <1300826388-22881-1-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.1103221601010.16870@router.home>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 22 Mar 2011 17:17:56 -0400
X-Google-Sender-Auth: GKbH_3qEPl6L7VFUZq9dliDUQUU
Message-ID: <AANLkTikCycUCyc9nqtFzYPUX2kSuWPLX-y=jXaJ4RomR@mail.gmail.com>
Subject: Re: [PATCH] percpu: cast away printk format warning
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 17:03, Christoph Lameter <wrote:
> On Tue, 22 Mar 2011, Mike Frysinger wrote:
>> So add an explicit cast to unsigned long here.
>
> I believe we have a format character %t to avoid the cast.

thanks, i wasnt aware of the ptrdiff_t extension.  i'll send out an update.
-mike

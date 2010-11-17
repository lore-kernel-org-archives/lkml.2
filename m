Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab0KQD2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:28:21 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36988 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab0KQD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:28:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bsVH8s3QSIWxNysnKO8SmT42v9GaODAsQy73vfNzFhSKzAAJzrIJQSoE4B1lzRCQZ9
         QQDXC2bA0y7g4EIRuc6/hI9EoZyNstjUmM7I84OFTBFboNuYwKfecENHjIiMOohcclzR
         Dw23RgSL5vQqvB9grUrrN6NanBS6U0B+qMXfk=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011151557510.7420@pobox.suse.cz>
References: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
	<alpine.LNX.2.00.1011151557510.7420@pobox.suse.cz>
Date: Tue, 16 Nov 2010 22:28:19 -0500
Message-ID: <AANLkTikKTLpzafaE9oxRz1f_ZE9zv1eL6K8aAkYmR+TB@mail.gmail.com>
Subject: Re: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
From: Tracey Dent <tdent48227@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: dmitry.torokhov@gmail.com, chatty@enac.fr, spbnick@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/10, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 7 Nov 2010, Tracey Dent wrote:
>
>> Changed Makefile to use <modules>-y instead of <modules>-objs because
>> -objs is deprecated and should now be switched. According to
>> (documentation/kbuild/makefiles.txt).
>
> Actually, where exactly does this file document it?
>

It documents how it should be done in the section entitled --- 3.7
Compilation flags (which starts on line 284).

> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

regards

Tracey Dent

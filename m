Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168Ab1D2XWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:22:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53687 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab1D2XWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pv950QRjOXgihB1LT8Ukk1vtUSRJZ5NyE6nw+yaRH9qrc1DAILCpzkfdeAGJgy9aOB
         pdiOboDojT8oiT4oepSFFbexR6v8iOBRMM8a9AA0wwAEB9aY06MrFvcUvvnLCo3JmkXA
         jy8SaxwusQphhujRX/T7KR3vNMcEe6Edaw82Y=
MIME-Version: 1.0
In-Reply-To: <4DBB450E.7080208@verizon.net>
References: <4DBB3DD4.9000000@verizon.net>
	<20110429154649.848f9ba8.rdunlap@xenotime.net>
	<4DBB450E.7080208@verizon.net>
Date: Fri, 29 Apr 2011 19:22:48 -0400
Message-ID: <BANLkTikEYUXhJkfXcV54vBvXy8r6UHpWSA@mail.gmail.com>
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to scripts/docproc.c
From: Arnaud Lacombe <lacombar@gmail.com>
To: pefoley2@verizon.net
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 29, 2011 at 7:09 PM, Peter Foley <pefoley2@verizon.net> wrote:
> [...]
> See https://lkml.org/lkml/2011/4/29/89 for the attachment request.
> My current email client (thunderbird) seems to mangle any patches that I send.
> If anybody can suggest an email client that doesn't mangle patches I'll be happy to try it.
>
You can use git-send-email(1) directly.

 - Arnaud

> Thanks,
>
> Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

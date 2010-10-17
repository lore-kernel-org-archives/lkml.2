Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab0JQKpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:45:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51068 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab0JQKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ikI1nke1jVpIYAQsdjD96Dg0PkdA+dOFQUzHyb+kLvGsu32K4A75N8mcpg3tQMkURY
         bQcm06vFdoKWc2xjdanY94e5VPsYJ0FZeAL4Ca5OWtpPO4kurVqfCoiDtbkBEx7lhNw/
         D5JK0kWByjJMJHyL9plhH8EE7HDq9aSPFwhpc=
MIME-Version: 1.0
In-Reply-To: <4CBA6338.20700@teksavvy.com>
References: <1287200493-2024-1-git-send-email-tdent48227@gmail.com>
	<4CBA6338.20700@teksavvy.com>
Date: Sun, 17 Oct 2010 06:45:33 -0400
Message-ID: <AANLkTi=39JTBALKH2zi118_a9kx_wpH2TyBY5LA6d9fe@mail.gmail.com>
Subject: Re: [PATCH] Drivers: ata: Makefile: replace the use of <module>-objs
 with <module>-y
From: Tracey Dent <tdent48227@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/10, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-10-15 11:41 PM, Tracey Dent wrote:
>> Changed<module>-objs to<module>-y in Makefile.
> ..
>> -libata-objs	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
>> +libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
>
>
> Why?
>

Using <module>-objs is deprecated and should now be replaced with
<module>-y(which is specified in Documentation/kbuild/makefiles.txt).

Regards,

Tracey D

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0GZBLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 21:11:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43921 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0GZBLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 21:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LjbeLxcY13KSm89xEOEYOmgdX49nCOOr9ucG2UEtF9YuA7xXvjFeM+gFispt4bzCvj
         nNlBWtL2NrgxGZbN3WA6pcahv/lgM059p97xcBgitLQgox3KrpMuZ9PFtz2YbZkw/DTC
         HL7YVy8xTY57DwjOa9aEhbbKiz5XfD5zRzggk=
MIME-Version: 1.0
In-Reply-To: <4C4C57D7.8090804@gmail.com>
References: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
	<4C4C57D7.8090804@gmail.com>
Date: Mon, 26 Jul 2010 11:11:13 +1000
Message-ID: <AANLkTikYo26zww3gWeWs_C4DyedMTFiciU51FRfV6t_z@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: comedidev: Removed unused macro 
	definitions
From: Michael Jensen <emjay1988@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As you are removing COMEDI_MODULE_MACROS, it makes sense to remove
> COMEDI_INITCLEANUP too.
>
>>       COMEDI_INITCLEANUP_NOMODULE(x)
>
>
> --
> js
>

Disregard this patch, comedi drivers are still using this macro, via
COMEDI_INITCLEANUP (compile fails at comedi/drivers/8255.c)

-- 
Regards,

Michael Jensen

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab1CaK5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:57:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57496 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab1CaK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qUfeEJAyKxYHc0eqNqUbJjuHOjkCDONdu6WHDX5Tt1q/5rKRdS38FDUDnaYCrb/D4h
         iUe5Edv++TxF3sQIwbYmRiMcHb9AfO9WYH8TynPL5ir+AFwH4iBYrr+SAvOHyoBxkqB6
         x/P9c4AAiMtp8XamGdxalGqT0+Znr5rY1CvQ8=
Message-ID: <4D945E14.1060708@gmail.com>
Date: Thu, 31 Mar 2011 12:57:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Roland Dreier <roland@purestorage.com>
CC: Klaus Dittrich <kladit@arcor.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.37.6 2.6.38.2 tst-aio4.c
References: <4D90CDDE.1020500@df1tl.local.here> <AANLkTikzU=zNrjs=mnLnxm3SUBAyVpWF5UmkJvXFnF-G@mail.gmail.com> <4D91ED6B.5020100@gmail.com> <AANLkTi=bgjiyEjZ+L2eOMmJ1us6pB83tnK3pS0jQHO6G@mail.gmail.com>
In-Reply-To: <AANLkTi=bgjiyEjZ+L2eOMmJ1us6pB83tnK3pS0jQHO6G@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 11:07 PM, Roland Dreier wrote:
>> Is there a patch for this already?
> 
> Yes, it is 243b422af9ea in Linus's tree.

Thanks. (Queued up for suse kernels.)

-- 
js

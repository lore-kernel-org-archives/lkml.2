Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209Ab0D3SzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:55:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33469 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200Ab0D3Syy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rDtd4Ss3Gmb+lq7+huVinpFF/WyFeFqfMAKvTnbK1JjLMg+jucHSCn5Y5sKKbA2RNH
         vdmjN8X+hT7o6Xnz/vCNI3wEJmNjVdrFszyfMxhlC/oclMT631BDLF6v4l9RxGvEaWBH
         cprSnNXZ/0rIeSyAo6/jYNCV7f5ZWA4AFk/+g=
Message-ID: <4BD925AA.5060902@gmail.com>
Date: Thu, 29 Apr 2010 08:22:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.6 Thunderbird/3.1b1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH 3/5] PM / Hibernate: separate block_io
References: <1272356118-10012-1-git-send-email-jslaby@suse.cz> <1272356118-10012-3-git-send-email-jslaby@suse.cz> <20100428055244.GA3501@ucw.cz>
In-Reply-To: <20100428055244.GA3501@ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 07:52 AM, Pavel Machek wrote:
>> + * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
> 
> That address no longer works, but keeps popping up....

Oops, it's a cut&paste from swap.c:
$ grep -r pavel.*suse kernel/power/
kernel/power/snapshot.c: * Copyright (C) 1998-2005 Pavel Machek
<pavel@suse.cz>
kernel/power/swap.c: * Copyright (C) 1998,2001-2005 Pavel Machek
<pavel@suse.cz>
kernel/power/hibernate.c: * Copyright (c) 2004 Pavel Machek <pavel@suse.cz>

-- 
js

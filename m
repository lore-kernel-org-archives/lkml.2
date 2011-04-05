Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1DEQKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:10:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37370 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1DEQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=Uzkrecmy9JeTBLX46OYKXdBWe3qeo53qU4Rj909pyNeYw72zRaatmqHkLweShnPMfv
         caWRYgYok7koDI7RMnZ/B89geo/9OFabPeIXrmshuRUC1njUt95imyV54pwG77r1feyx
         e7FD2qYhKulmOwoJChIFhV/yqHDGC+LKtfp2I=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] fixes for f_mass_storage
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 18:10:42 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg274um3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 17:36:37 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> These patches contain some fixes and improvements for f_mass_storage.c

Thanks for the fixes!  Comments follow each patch.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--

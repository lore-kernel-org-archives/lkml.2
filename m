Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab1CaOJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:09:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab1CaOJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oaUmJILka7OfjiV33JU9XvC/hoQZ/TbEzwG55xk3FLohbRJ0iYi7hN+4XhxdvRXfGN
         71rrvOWIKDlI7y6ubKFyRFIIHe+rfi2O8oLjtfH157LiEXh3Tlet5ISvXTFit9RKWFcm
         OXqj6dTXuisILoMNfpXUJWgT7KX0y7v8SZO4k=
Message-ID: <4D948B1C.7080806@suse.cz>
Date: Thu, 31 Mar 2011 16:09:32 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Arend van Spriel <arend@broadcom.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        devel@linuxdriverproject.org, gregkh@suse.de,
        linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
 in separate module
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz> <201103301453.48607.arnd@arndb.de> <4D948624.3040605@suse.cz> <20110331135126.GC19540@flint.arm.linux.org.uk>
In-Reply-To: <20110331135126.GC19540@flint.arm.linux.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 03:51 PM, Russell King wrote:
> On Thu, Mar 31, 2011 at 03:48:20PM +0200, Jiri Slaby wrote:
>> How it can? Packed only tells the compiler to have one byte alignment
>> steps. And it should not matter here as all the members are 32-bit long.
> 
> It also tells the compiler that it may be misaligned, so to avoid
> alignment faults it will use byte loads/stores.

No, it should not (if offsetof % sizeof == 0). Otherwise it's a bug in
the compiler.

Am I missing something?

thanks,
-- 
js
suse labs

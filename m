Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1FPH0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:26:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39765 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab1FPH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vHbi8sjaBcS1gtYBd07/o5NhwmGeSfGyVGe6BfHoH77XuI+vPq3qDjGDPVPOAl15hi
         QG1eGaPvni5wR/6Xc30qlWr0GzxkwYs1fHKxy4+jqPC6G9MOkyjXEEby+MEAr0/dfoMt
         DSewRbSOcebwcaexJOndavpZdBZmqr8UfU6Jg=
Message-ID: <4DF9B00A.8070903@gmail.com>
Date: Thu, 16 Jun 2011 09:26:02 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] xhci: Add reset on resume quirk for asrock p67 host
References: <4DF92869.50105@gmail.com> <20110615224338.GA8705@xanatos>
In-Reply-To: <20110615224338.GA8705@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

Op 16-06-11 00:43, Sarah Sharp schreef:
> No attached patches, just inline ones please. :)  I've fixed this up for
> now, since your first patch was inline.
Actually, it seems I did it both ways by accident. Testing patch -Np1
with that message still worked. Sorry about that. Sent it right before
falling asleep.


~Maarten

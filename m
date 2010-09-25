Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0IYTap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 15:30:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50153 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0IYTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 15:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hnKoY5cgqfMTotgJz1m6FHBsIZ7TLkvZ5n+ZsYDtMDy7XyCKXxI2SqcePxNL00iBBd
         Jhyy2P2ylRDNOcJs3xbV5YpHvHMpSnBn80ntD4/BrYT22kKZgKeBwu7kQkZIJwg/+k6L
         ByTWz+s2JTmxUiO8nqBPq7dZ+hX2EAMWEg1AA=
Message-ID: <4C9E4DDB.6070503@gmail.com>
Date: Sat, 25 Sep 2010 22:30:35 +0300
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
References: <4C03C608.1040600@gmail.com> <20100601135004.GP15159@redhat.com> <4C051D44.7040203@gmail.com> <20100602184459.GA15159@redhat.com> <4C0B3E94.6020506@gmail.com> <4C80B338.6020701@gmail.com> <20100903135613.GV4879@redhat.com> <4C9CBF4A.9060302@gmail.com> <20100924191946.GS26290@redhat.com>
In-Reply-To: <20100924191946.GS26290@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 10:19 PM, Don Zickus wrote:
> Actually there seems to have been some clean up in the cpu hotplug error
> handling code.  Could you remove that snippet of code and see if the
> problem still happens?

The thing is I don't remember what problems exactly I had. From the
description I wrote, I cannot reproduce it anymore :).

thanks for looking into that,
-- 
js

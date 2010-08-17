Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0HQKSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:18:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab0HQKSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Iot06l/tVNsR1WbRtpkiyOSNiljcxTqKhBcJz+uBHEjduKhkx4BbIvkboGlJg63Mm1
         5kKGtBmVkDNQFlnYCxHduQ1uqgVn6hWvct+uBSSDd/Y4FZUP8mIIXn1XAPZc8j74zMNE
         mHHl8l6SKjx/WV1dmVnVY7X1HKW8g1kpLgFQo=
Message-ID: <4C6A6145.7020707@gmail.com>
Date: Tue, 17 Aug 2010 12:15:33 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008170951.26073.stephan.diestelhorst@amd.com> <4C6A4395.8080804@gmail.com> <201008171132.56431.stephan.diestelhorst@amd.com>
In-Reply-To: <201008171132.56431.stephan.diestelhorst@amd.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 11:32 AM, Stephan Diestelhorst wrote:
> Indeed. Like I said, I have similar issues on a another Samsung HDD in
> an AMD system. I have not yet got around to try the fix there, but I
> suspect it is the same thing.
> 
> I have attached the full /var/log/messages and /var/log/kern.log with
> multiple suspend-to-ram runs and the last one failing.

Hmm... are you sure the patch is applied?  There's no debug message
outputs in the log which the patch added.

> Would it make sense to add Rafael's workaround upstream, maybe enabling
> it only for particular platforms / HDDs / with a parameter?

Yeah, maybe.  The problem is that I'm a bit reluctant to do that for
all cases as it may cause other obscure failures and we don't know
whether the problem is controller or device specific at this point,
so...

Thanks.

-- 
tejun

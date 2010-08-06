Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab0HFHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:06:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab0HFHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=akeuFkt0Tyz2x16+1vmG66u2ofa5zug3hxqet3i2Q5j8JYfsLIY/8lTIixtkjMQjHa
         yWuicGT+Iq0I3/6rPcWOgyv+DtkFJkRzp7E9NpTMUGZZtVHPHeobc4Js2Gsn5VUwE07H
         XuhqrENGDBqIMdKuzfHdR3yVn02wvVAcui0sM=
Message-ID: <4C5BB472.5000207@gmail.com>
Date: Fri, 06 Aug 2010 09:06:26 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C52DF50.80009@kernel.org> <4C5AE1E2.6070601@gmail.com> <201008060830.50889.stephan.diestelhorst@amd.com>
In-Reply-To: <201008060830.50889.stephan.diestelhorst@amd.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/06/2010 08:30 AM, Stephan Diestelhorst wrote:
> On Thursday 05 August 2010, 18:08:02 Tejun Heo wrote:
>> Can you please try the following patch and see whether the problem
>> goes away?
> <snip>
> 
> to which revision does the patch apply? I didn't get it to apply
> cleanly to Linus' kernel HEAD or the 2.6.34 stable tag. Maybe I am
> missing something, since I am a git-n00b (use Mercurial all the time)?

It applies cleanly to v2.6.35.

Thanks.

-- 
tejun

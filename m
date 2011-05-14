Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab1ENSti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:49:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56772 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1ENStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QzJtSv+rvwE7LOSBhKUgNjb2S/zEGk9v7stfO9SDQZ+jxP476rnV1c3G6HnrJb/6XT
         srvGhpy8xWYlwe1/De8G7tN3zoGSzbGfS2zwVSXdLv5RnmACUoUpfnEIUaRm2xK0Vn3q
         xJFVFlciBHX1uRXDgSpGI/tNgOguuk9aK3VFA=
Message-ID: <4DCECEBC.10705@pobox.com>
Date: Sat, 14 May 2011 14:49:32 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Michael Leun <lkml20100708@newton.leun.net>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jian Peng <jipeng2005@gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant
 to AHCI spec"
References: <201105120025.34531.rjw@sisk.pl> <BANLkTimqxmbpP1-+HxhPQS-YoLTh=bHd1Q@mail.gmail.com> <201105132222.11582.rjw@sisk.pl> <201105132244.29605.rjw@sisk.pl> <20110514101807.GA23665@htj.dyndns.org> <20110514102804.GB23665@htj.dyndns.org> <BANLkTi=BNu8mdafPVtbqbKpK4ZcjDDR=YQ@mail.gmail.com>
In-Reply-To: <BANLkTi=BNu8mdafPVtbqbKpK4ZcjDDR=YQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2011 01:47 PM, Linus Torvalds wrote:
> On Sat, May 14, 2011 at 3:28 AM, Tejun Heo<tj@kernel.org>  wrote:
>>
>> As we're already in -rc7, I'm sending the revert patch to both Jeff
>> and Linus.
>
> Applied,

ACK, thanks



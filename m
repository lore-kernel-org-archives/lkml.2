Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0ITWHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:07:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60358 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0ITWHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=B5zD27eZJikXid2AlpcII2TZ2HqTPOc/plQmpciCS+KLzaxKord1Klyyg7zRAtChch
         SkSICXApvEssvw+uTUZMXkN0F2ICUNDPmTRdEe8kMFfMNL/yJkIpie/n6ezAR4f+da4p
         YR+vJJ8Ax2KMc8Oq0vT3L30iup+Kd6xnBxM60=
Message-ID: <4C97DB80.4060403@gmail.com>
Date: Tue, 21 Sep 2010 00:09:04 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pedro Francisco <pedrogfrancisco@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ahci rmmodable and shouldn't
References: <201009162256.04765.pedrogfrancisco@gmail.com> <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net> <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2> <4C9602E4.4090007@gmail.com> <1284974726.11757.9.camel@sundae-v2> <4C9729D7.70500@gmail.com>  <4C972C60.8010506@gmail.com> <1285015465.26023.10.camel@sundae-v2>
In-Reply-To: <1285015465.26023.10.camel@sundae-v2>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/20/2010 10:44 PM, Pedro Francisco wrote:
> To which tree shall I apply it? It currently fails both on Linus'
> linux-2.6 and
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git .

Hmm... weird.  It's against Linus' tree.  Checking, yeap, it applies
cleanly to 2.6.36-rc4, commit 2422084a (Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6).

Thanks.

-- 
tejun

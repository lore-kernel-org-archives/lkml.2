Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1CPTXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:23:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1CPTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AF3ixBzV6xku3iTqVfFWeXkuI3tCQ0EQbimuSSjuwr3+IFwMGNe2EpAgdjI8BnSh7o
         7ZyX+UgcUMuIbJmUaT9Pc92x1687E0JMkSpAMFMOLBCzXpH5WJmJYIXAIgN6SM1NG9BW
         7rhc02Ka1Bp51wxOVcCv8hD0SU+X0Q54CSzIk=
Message-ID: <4D810E12.9050801@gmail.com>
Date: Wed, 16 Mar 2011 20:22:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Melchior FRANZ <melchior.franz@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915/kms regression after 2.6.38-rc8
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <201103161830.52231@rk-nord.at>
In-Reply-To: <201103161830.52231@rk-nord.at>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing some relevant people (you should have done this).

On 03/16/2011 06:30 PM, Melchior FRANZ wrote:
> On my i915 using Acer TravelMate 5735z I could run kernel 2.6.38-rc8
> with KMS. On 2.6.38 I get a black screen instead. In case anyone
> cares, just tell me what information you need. (bisect result on
> request, but I assume the experts know which patch caused it.)


-- 
js

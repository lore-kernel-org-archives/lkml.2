Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0HDG5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:57:06 -0400
Received: from mail.aixigo.de ([195.14.232.227]:31443 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab0HDG5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:57:04 -0400
Message-ID: <4C590F16.2030109@aixigo.de>
Date: Wed, 04 Aug 2010 08:56:22 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100721 Mnenhy/0.8.3 Thunderbird/3.1.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be fully
 populated"
References: <4BFB947E.9080509@aixigo.de> <20100525184621.89487735.akpm@linux-foundation.org> <AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com> <4BFD1F93.7080000@aixigo.de> <4C57BF1E.9080804@aixigo.de> <20100803151445.GD31368@kroah.com>
In-Reply-To: <20100803151445.GD31368@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/10 17:14, Greg KH wrote:
> 
> Sounds like an ACPI bug.  The ACPI developers use the
> bugzilla.kernel.org site to track things like this.  Try filing a bug
> there and they can take care of it.
> 

Done: https://bugzilla.kernel.org/show_bug.cgi?id=16097


Many thanx

Harri

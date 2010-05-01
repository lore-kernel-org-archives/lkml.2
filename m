Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0EASo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:44:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:5847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab0EASo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F/eDduEnhyR5u+SYRxMBPMb+ALOBfhnWx8fS+SbZZ6wpVvEHx5KOdK990Eg0Ejcldi
         R+pbSHhJbEudL1QX2N4eoFcpkDJ4AMPzi9Vri1i975zVQDd+/D5xFdmZTO8MOkhb9bCT
         XHi1WLwNs1/ji8Nj4OhzQhOW8BVQRWjz/hyaI=
Message-ID: <4BDC7685.1040001@gmail.com>
Date: Sat, 01 May 2010 10:44:21 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100422 Shredder/3.0.5pre
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Bcache: version 4
References: <20100501001244.GB31135@moria> <20100501084000.9c327ac5.rdunlap@xenotime.net>
In-Reply-To: <20100501084000.9c327ac5.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2010 07:40 AM, Randy Dunlap wrote:
> On Fri, 30 Apr 2010 16:12:44 -0800 Kent Overstreet wrote:
>> +	"echo /dev/foo">  /sys/kernel/bcache/register_cache
>> +	And to enable caching for a device
>> +	"echo<UUID>  /dev/foo">  /sys/kernel/bcache/register_dev
>
> Aren't the quotation marks misplaced in these examples?

Doh, yes. How embarrassing, it's fixed now.

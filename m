Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0D1UUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:20:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:45980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166Ab0D1UUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:20:34 -0400
Message-ID: <4BD89880.40509@kernel.org>
Date: Wed, 28 Apr 2010 22:20:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Harald Arnesen <harald@skogtun.org>
CC: trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org> <87r5lzpgfy.fsf@basilikum.skogtun.org>
In-Reply-To: <87r5lzpgfy.fsf@basilikum.skogtun.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 20:20:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 08:42 PM, Harald Arnesen wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
>> causes annoying problems with some editors and tools.  Use (C)
>> instead.
> 
> Why do we need anything there at all?

We don't necessarily need it but it's also pretty rude to strip
other's copyright notices and other entries use (C), so.... :-)

-- 
tejun

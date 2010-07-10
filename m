Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0GJVhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54078 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0GJVhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:37:10 -0400
Message-ID: <4C38E7CA.30100@zytor.com>
Date: Sat, 10 Jul 2010 14:36:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi> <20100710210750.GC6615@lenovo> <AANLkTim1wgrOaz5rXV-Cea3IjcZejrsRrCO0AUkcrOv-@mail.gmail.com> <20100710213211.GD6615@lenovo>
In-Reply-To: <20100710213211.GD6615@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 02:32 PM, Cyrill Gorcunov wrote:
>>
>> Yes, but I followed 'isdigit' here for symmetry and it uses 'int'.
>>
> 
> ok, I see
> 

At the time the code was written, "bool" use in the kernel was still not
really accepted as a matter of style.  I think that has changed now and
"bool" is preferred, except as input/output to asm statements (we don't
yet trust gcc to do it sanely across versions.)

As such, changing that would be good, but should be done as a separate
thing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


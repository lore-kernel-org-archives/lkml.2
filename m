Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2EYPHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:07:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60639 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751414Ab2EYPHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:07:19 -0400
Message-ID: <1337958437.30100.2.camel@joe2Laptop>
Subject: Re: [RFC] vsprintf: Add %pMR for Bluetooth MAC address
From: Joe Perches <joe@perches.com>
To: andrei.emeltchenko.news@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Date: Fri, 25 May 2012 08:07:17 -0700
In-Reply-To: <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
References: <1336778486.16292.0.camel@joe2Laptop>
	 <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 17:32 +0300, andrei.emeltchenko.news@gmail.com
wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Hi Andrei.

Just trivia:

> @@ -830,6 +840,7 @@ int kptr_restrict __read_mostly;
>   * - 'm' For a 6-byte MAC address, it prints the hex address without colons
>   * - 'MF' For a 6-byte MAC FDDI address, it prints the address
>   *       with a dash-separated hex notation
> + * - '[mM]R For a 6-byte MAC Bluetooth address, bits reversed

Reverse order

>   * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
>   *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
>   *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
> @@ -890,7 +901,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		return resource_string(buf, end, ptr, spec, fmt);
>  	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
>  	case 'm':			/* Contiguous: 000102030405 */
> -					/* [mM]F (FDDI, bit reversed) */
> +					/* [mM]F (FDDI) */
> +					/* [mM]R (Bluetooth, bits reversed) */

here too



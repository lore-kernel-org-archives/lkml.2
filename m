Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0KYHGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:06:32 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:52598 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab0KYHGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:06:30 -0500
Message-ID: <4CEE0AF1.7030208@lougher.demon.co.uk>
Date: Thu, 25 Nov 2010 07:06:25 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux armv7l; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: Lasse Collin <lasse.collin@tukaani.org>, linux-kernel@vger.kernel.org,
        linux-embedded@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC 2/3] Decompressors: Add boot-time XZ support
References: <201011242254.41176.lasse.collin@tukaani.org> <4CEE02EE.1050102@lougher.demon.co.uk>
In-Reply-To: <4CEE02EE.1050102@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/10 06:32, Phillip Lougher wrote:
>> +
>> + for (i = 0; i< size; ++i)
>
> The kernel uses either "i < size" or "i<size" ...
>

Disregard these, looks like my email client (Mozilla Thunderbird)
is eating spaces... Very odd

>> + if (fill == NULL&& flush == NULL) {
>

and this.


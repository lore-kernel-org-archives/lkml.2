Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0KXWuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:50:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0KXWuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:50:54 -0500
Message-ID: <4CED96A4.1080608@zytor.com>
Date: Wed, 24 Nov 2010 14:50:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lasse Collin <lasse.collin@tukaani.org>, linux-kernel@vger.kernel.org,
        linux-embedded@vger.kernel.org, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH RFC 1/3] Decompressors: Add XZ decompressor module
References: <201011242251.52927.lasse.collin@tukaani.org> <20101124142549.c1b9ad14.akpm@linux-foundation.org>
In-Reply-To: <20101124142549.c1b9ad14.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 02:25 PM, Andrew Morton wrote:
>>
>> This patch: Add the main decompression code (xz_dec), testing
>> module (xz_dec_test), wrapper script (xz_wrap.sh) for the xz
>> command line tool, and documentation. The xz_dec module is
>> enough to have a usable XZ decompressor e.g. for Squashfs.
> 
> I'm not seeing any documentation which tells me how to create, install
> and execute xs-compressed kernels. There are new makefile targets?
> 

Logically it should be an additional CONFIG option like we currently
have for the other compression formats.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KFPDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:03:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51967 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab0KFPDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Uvflo3d5V8mLMlcHKXTZXyEdEoVbe3DMXG8MPEv1px0Wdf6VWfzUjBG7oszH5TbEms
         kEtOTP+9FMoCW2ztGsOR4ogIXTInxyDmhfG0oxAkH1o0Mrigh0pd6Z4aCoE1nMWoXQez
         fzQ6E4C3dFi6JpjZYwb9gjqpoXdK/Qpj65OGQ=
Message-ID: <4CD56D67.9090106@gmail.com>
Date: Sat, 06 Nov 2010 15:59:51 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/16 v2] pramfs: super block operations
References: <4CD51847.20306@gmail.com> <20101106111627.GA13497@gandalf.local>
In-Reply-To: <20101106111627.GA13497@gandalf.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/11/2010 12:16, James Hogan ha scritto:
> Hi Marco,
> 
> On Sat, Nov 06, 2010 at 09:56:39AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>> +static void pram_set_blocksize(struct super_block *sb, unsigned long size)
>> +{
>> +	int bits;
>> +
>> +	/*
>> +	* We've already validated the user input and the value here must be
>> +	* between PRAM_MAX_BLOCK_SIZE and PRAM_MIN_BLOCK_SIZE
>> +	* and it must be a power of 2.
>> +	*/
> 
> Should this comment have spaces after the tabs to be consistent with the
> other multiline comments (pram_ioremap) and the coding style?
> 

Ok, no problem.

Thanks for the review.

Regards,

Marco

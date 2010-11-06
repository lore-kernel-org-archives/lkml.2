Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0KFPCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 11:02:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51967 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0KFPC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 11:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cIQprCyzjTlWvn3c54/H/BIXEi4IXSm9KW7vn5dgqEqU1SfjgxzbWdMekaLF/8gyUr
         UhxJMUncqkU0GnAncNoE7rxNLFTSVxbsqG+tTjmea2nLFzColHZyrf95P3sYmSGiS+5t
         +uHp+xzgHaosBKCGh8nEJz2HTX/TP4e9WOTDI=
Message-ID: <4CD56D43.2010803@gmail.com>
Date: Sat, 06 Nov 2010 15:59:15 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16 v2] pramfs: documentation
References: <4CD51832.7070309@gmail.com> <20101106103935.GA13172@gandalf.local>
In-Reply-To: <20101106103935.GA13172@gandalf.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/11/2010 11:39, James Hogan ha scritto:
> Hi,
> 
> On Sat, Nov 06, 2010 at 09:56:18AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>> +PRAMFS is write protected. The page table entries that map the backing-store
>> +RAM are normally marked read-only. Write operations into the filesystem
>> +temporarily mark the affected pages as writeable, the write operation is
>> +carried out with locks held, and then the page table entries is +marked read-only again.
>> +This feature provides protection against filesystem corruption caused by errant
> 
> Looks like an accidental lost newline in the patch here, should that be
> "are marked" or is there some text missing?
> 

My fault, a problem during email formatting. I'll resend this patch.

Marco

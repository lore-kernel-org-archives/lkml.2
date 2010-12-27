Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab0L0Ils (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 03:41:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58347 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0L0Ilp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 03:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DuK3Rr0OnLiJe4UIl5XcLJj70+p5zw7L2K+GggceWPNOVzoQtxQ8cBJ4XG4lugcEr4
         CuEF1kjOXraWBU9qh18ARaru1btCdE+n/MWNCE6bFvE4D+VQIG0LjlZIGV9/k6ata91T
         e1hQ8mKJi+Pv4pbNHg3AmJcMhsrbTFXKTPXp8=
Message-ID: <4D18506B.8070400@gmail.com>
Date: Mon, 27 Dec 2010 09:38:03 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Olaf van der Spek <olafvdspek@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Return value of generic xattr operations
References: <4D1748D4.5050700@gmail.com> <AANLkTik71N=OJOD5MvvBitUQM4C42-Q8HSrBc8NiBuSc@mail.gmail.com>
In-Reply-To: <AANLkTik71N=OJOD5MvvBitUQM4C42-Q8HSrBc8NiBuSc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/12/2010 22:15, Olaf van der Spek ha scritto:
> On Sun, Dec 26, 2010 at 2:53 PM, Marco Stornelli
> <marco.stornelli@gmail.com> wrote:
>> Hi,
>>
>> is it right that generic_setxattr & co. return -EOPNOTSUPP if there is a
>> namespace error? I mean, if the user try to set <my own namespace>.foo
>> attribute, the return value should be -EINVAL, isn't it? Operation not
> 
> Why?
> There are multiple errors and only one can be returned.
> 

Ok, but at least it should be return the most important. Man page said:
"If extended attributes are not supported by the file system, or are
disabled, errno is set to ENOTSUP.", but in this case this kind of error
is not really matching with this sentence, because the extended
attribute are supported by fs and they are enabled.

Marco

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1BGWfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:35:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1BGWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U5VTPqUTb+tqDoZkjhybuAXHTbjF4NZiHsFu/0D2exUhy/GTIVLWeTwMhfwQR6bTvm
         M2ILMafWErEt0fAQU4U3rJcH5A3UWXqnYAtHYqmpEBCq9w5V8UOK8ggHcRxVRgcuCE0r
         jlvNA1zV8FQC+DotE91tTXR4YCNVX2SgAwHpM=
Subject: Re: [RFC] Split up mm/bootmem.c
From: Namhyung Kim <namhyung@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim2GcBMMMr0tABf=3GwHX8oX05-Dn8tdZbYpt_b@mail.gmail.com>
References: <1297092614-1906-1-git-send-email-namhyung@gmail.com>
	 <AANLkTim2GcBMMMr0tABf=3GwHX8oX05-Dn8tdZbYpt_b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:35:13 +0900
Message-ID: <1297118113.1808.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-02-07 (월), 10:45 -0800, Yinghai Lu:
> On Mon, Feb 7, 2011 at 7:30 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> > The bootmem code contained many #ifdefs in it so that it could be
> > splitted into two files for the readability. The split was quite
> > mechanical and only function need to be shared was free_bootmem_late.
> >
> > Tested on x86-64 and um which use nobootmem and bootmem respectively.
> >
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> 
> https://lkml.org/lkml/2010/6/16/44
> ...
> 

Ah, you already made same patch before. OK, I'll drop mine then.
Thanks.


-- 
Regards,
Namhyung Kim



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1FOTwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:52:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41003 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1FOTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=LOuYklvUXrtUecLyTOeZbNacue4iLpvabnkViekgdgP4GZE1oowrt3Dpra05892i9w
         3xFDVRZUxMEI6v8oI8n8kXEDutZz82t2aG24smZG53qGlpPPAy3EFWhYq7O5J/vk5KuT
         5mZG1oPsjVULwYiy+aPmLD0PYVJGaevCPrKeQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTinJimOb4CMQeDm+Ob60N5v4QAMWwg@mail.gmail.com>
References: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com> <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com> <4DF7A264.3030901@mit.edu>
 <20110614211613.GB12249@elte.hu> <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
 <20110614213109.GA9725@elte.hu> <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
 <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com> <20110615072553.GA26003@elte.hu>
 <BANLkTinSac=XHNk7jnsYGDo06B=ChXsnAQ@mail.gmail.com> <BANLkTinxKV-Kprm+ezfbt2a=C1fz+-7wrg@mail.gmail.com>
 <BANLkTinJimOb4CMQeDm+Ob60N5v4QAMWwg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 15 Jun 2011 15:51:42 -0400
X-Google-Sender-Auth: 4IExyo3D9PCnY1l2yFc7zJTn21M
Message-ID: <BANLkTimuqh9up9hsmuCZJBmbg2fGSwOZUg@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Rakib Mullick <rakib.mullick@gmail.com>,
        hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 3:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If you're really worried about it ever triggering, then dammit, HANDLE THE CASE.

Like I said, I'll send a patch to handle the case.

--Andy

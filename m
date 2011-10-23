Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1JWGKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:10:22 -0400
Received: from guarana.org ([59.167.251.209]:55332 "EHLO protos.guarana.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752776Ab1JWGKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:10:20 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Oct 2011 02:10:20 EDT
Message-ID: <20111023162159.80444iahzf390vi8@guarana.org>
Date: Sun, 23 Oct 2011 16:21:59 +1100
From: Kevin Easton <kevin@guarana.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE
 mappings
References: <20111021213916.914462C0A5@topped-with-meat.com>
 <CA+55aFy3ALC34AyrsHi9yjBgRMwg9G5w2PhDfr_JVti1M8GbNQ@mail.gmail.com>
 <20111022172450.0BCCE2C0A9@topped-with-meat.com>
 <CA+55aFx_9D8jY2sqcZ+Tm305W9d8o+ZhEv8XNWuN4--S2bqRwQ@mail.gmail.com>
 <CA+55aFxNOS7ZTq9wgQEXNue9wZMqymdWSN+zTuXB-gLgX0gRNg@mail.gmail.com>
 <20111023100835.14682pfbxag3lkao@guarana.org>
 <CA+55aFydaGYx2nkeGps2kO2k=eV1m6xcFgH5okeqy1G8H=z+_w@mail.gmail.com>
In-Reply-To: <CA+55aFydaGYx2nkeGps2kO2k=eV1m6xcFgH5okeqy1G8H=z+_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds <torvalds@linux-foundation.org>:

> [ Resent, this seems to have gotten dropped by something. Sorry if it
> shows up twice  ]

My fault, looks like lkml.org trims the CC list to an unreasonably small
value.

> On Sun, Oct 23, 2011 at 2:08 AM, Kevin Easton <kevin@guarana.org> wrote:
>>
>> Won't this still allow silent probing, because the malicious user can
>> just try to create the mapping, then check in /proc/self/maps to see
>> if it really worked?
>
> Yup, right you are.
>
> So we shouldn't do that either, and probably just leave the current
> semantics, unless Roland (or others) can convince me that complicating
> the kernel  mmap security model really is worth it.
>
>             Linus





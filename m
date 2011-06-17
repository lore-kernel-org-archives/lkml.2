Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1FQFLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:11:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46294 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1FQFLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e+bMY1yyJ5lAFJN4LXhzGtUv+2w5hGdUuYerzkqo0oTL6+k8v3vcoarKFTRjkp+Mln
         0zmsr4WL6iNBpxzuR7uYcbPoDvLUWVjJseUwPLO4DpvfnuigNVmB7hzZlHaOq+svGrh/
         IpJbVcdgDaYFwqUd0qfGTUV40ZRFgcuT/itAs=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
References: <1308153214.7566.6.camel@jaguar>
	<BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
Date: Fri, 17 Jun 2011 06:11:41 +0100
Message-ID: <BANLkTi=A6mes-hWTgS+E6+j8vXxTcFbiqw@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 3:48 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Wed, Jun 15, 2011 at 6:53 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
>>  following URL for test result details: https://gist.github.com/1026888
>
> It turns out we were benchmarking the wrong guest kernel version for
> qemu-kvm which is why it performed so much worse. Here's a summary of
> qemu-kvm beating tools/kvm:
>
> https://raw.github.com/gist/1029359/9f9a714ecee64802c08a3455971e410d5029370b/gistfile1.txt

Thanks for digging into the results so quickly and rerunning.

Stefan

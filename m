Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab1FPOs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:48:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53198 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394Ab1FPOsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=McFKeH1skLw3m5Ow1DXQnZ+RMvdfhiAhAOAEBSv9HGdYHEpwcql+0GZHdp6FK/4cKV
         R/9hzOofyMcuKzZxNWtjbGBXt1yx2K+TRTCAW4kMBT9zuIw49NpAzhJiZMegGdG790FP
         jbP0qMp/y1+tzRaeAgjsciYbNx+2PCb1+a1xA=
MIME-Version: 1.0
In-Reply-To: <1308153214.7566.6.camel@jaguar>
References: <1308153214.7566.6.camel@jaguar>
Date: Thu, 16 Jun 2011 17:48:21 +0300
X-Google-Sender-Auth: YPw-X7l7zBy7GcrohHTBklAaUa0
Message-ID: <BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 6:53 PM, Pekka Enberg <penberg@kernel.org> wrote:
> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
>  following URL for test result details: https://gist.github.com/1026888

It turns out we were benchmarking the wrong guest kernel version for
qemu-kvm which is why it performed so much worse. Here's a summary of
qemu-kvm beating tools/kvm:

https://raw.github.com/gist/1029359/9f9a714ecee64802c08a3455971e410d5029370b/gistfile1.txt

I'd ask for a brown paper bag if I wasn't so busy eating my hat at the moment.

                        Pekka

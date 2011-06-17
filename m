Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1FQHbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:31:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42705 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab1FQHbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XvD2ITUKuvoRuvdTRGAWXOgD4pDGL6yxH2LwEcxBvkTAzNcY04CT+mdL7NfclDJ2h7
         B2ewlhqEERpkXqGTZKlTa3Guo9g4BfkGJYONxbEZ5T5AYALvg50sn7/27d3+zE/DRiP+
         ugcZyfAXScUtLumOCi9zjlQE5Gr66/Ng89Urk=
Message-ID: <4DFB02CA.1040409@gmail.com>
Date: Fri, 17 Jun 2011 15:31:22 +0800
From: justin <iamljj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <1308153214.7566.6.camel@jaguar>
In-Reply-To: <1308153214.7566.6.camel@jaguar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年06月15日 23:53, Pekka Enberg wrote:
> or alternatively, if you already have a kernel source tree:
>
>    git remote add kvm-tool git://github.com/penberg/linux-kvm.git
>    git remote update
>    git checkout -b kvm-tool/master kvm-tool
I tried this, but it do not work, there is something wrong when I 
executed the 3rd git command.
I tried "git checkout -b tools/kvm kvm-tool/master", it seems works fine.

-- 
justin


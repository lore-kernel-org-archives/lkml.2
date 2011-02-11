Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab1BKP54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:57:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59791 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab1BKP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:57:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=Nybm32B5rASL//xR9zVvnycvzVcofMe2SZPNOix+cTZZSdIaFQZTQURG56xJf8lgFg
         grfKBygg6ZpXbB6pwkPRnek5xwDWCSORHV+tE78TSemUo89klq3lWUonGGnq35o7kIz4
         pq+tkrM4v3ie5qd3cO3Au6tqa6DzE4hWQ+pyA=
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Message-Id: <C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen flicker like its broken or half plugged in
Date: Fri, 11 Feb 2011 07:57:50 -0800
References: <4D51AD03.7030401@gmail.com> <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com> <AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com> <B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com> <AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com> <AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Better yet, can you try the attached patch on top of 2.6.38-rc4 or  
> newer?
>
> Alex
>

o.k. applied that patch... unfortunately Im seeing the flickering  
screen and the crud shows up..
initially during boot everything looked fine, its when I suspended the  
machine, upon wake-up
the flickering occurred.
kernel version is the current: 2.6.38-rc4-00107-gaa502b4

Justin P. Mattock

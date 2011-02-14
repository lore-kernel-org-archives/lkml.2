Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1BNACu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 19:02:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58921 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab1BNACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 19:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=qLRxpZ3aGpmxqJq9q0wq1KDLRPLNhSp97nKFyLzKPWnPwsvyJ5IOBzG+wWw8NaK6DC
         0JrorulZiQjeZaXjlfRzOa0jiF4yDfM8Gm1GmygmaWcH6W3I07JMmkMoAxqGeUcc6tg+
         GpPHwgoKGuurBUj0ZeXBT1sPzxo8n5q3Vqieo=
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Message-Id: <C1FCA772-17F8-430D-9897-04CA9D91C902@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <AANLkTikrZZ6i6di-c0zBav0zT5OOvmOXvX7SAXTW18z+@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen flicker like its broken or half plugged in
Date: Sun, 13 Feb 2011 16:02:39 -0800
References: <4D51AD03.7030401@gmail.com> <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com> <AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com> <B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com> <AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com> <AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com> <C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com> <AANLkTinca2027s9-g0tLabBMj4fr2+e=xgUSymBqvv1o@mail.gmail.com> <1838D776-BF70-4ABE-98CB-EFDCF828F6CF@gmail.com> <AANLkTikrZZ6i6di-c0zBav0zT5OOvmOXvX7SAXTW18z+@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The attached patch is what I'm proposing to go upstream.  Please test
> and let me know if it works ok for you.
>
> Alex
>

o.k.!! I have 6 revisions to test on another issue, then I can throw  
this in and let you know..

Justin P. Mattock


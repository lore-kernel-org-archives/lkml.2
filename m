Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab1FWOxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:53:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43432 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1FWOxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=vNNMcQL5bjDPIPFatwT7D6rGUC+j5sCPmxIDO7BoX3+j+XowOaaXLmBT/uucUoEJlF
         IP2Qw3RLI6HF0K6eHdwyksERaCA0MtxWsAiODhoymcH5IZjVcSO53aSes11fa0zdzPn9
         BbX8fkhp1nP8N2ew/MMFbSI2KAQ8sv4iQKyBU=
MIME-Version: 1.0
In-Reply-To: <4E034E2A.1010100@msgid.tls.msk.ru>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
 <20110623153116.404f2a63.taeuber@bbaw.de> <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
 <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com> <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
 <4E034E2A.1010100@msgid.tls.msk.ru>
From: yuyichao-mit <yuyichao@mit.edu>
Date: Thu, 23 Jun 2011 10:53:17 -0400
X-Google-Sender-Auth: aWUN7xL4usKsTOthamYlwntyXwA
Message-ID: <BANLkTi=ZS8itWV+jHn2XxZ--P8cU3jFQQg@mail.gmail.com>
Subject: Re: extra slash in current path
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>,
        linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:31 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> 23.06.2011 18:11, yuyichao-mit wrote:
>
>>>>> $ cd //
>>>>> $ pwd
>>>>> //
>
> The current directory is cached in $PWD environment
> variable by shell (bash at least).  This variable is
> checked in glibc (getcwd() et al) - if it is set and
> stat($PWD) is the same as stat("."), that value is used.
>
> It has nothing to do with kernel, probably the issue
> is in bash which somehow allows double slash for root
> dir (but not triple).

u r right. chdir in c and cd in csh doesn't have this problem.

it is bash stuff.

>
> /mjt
>

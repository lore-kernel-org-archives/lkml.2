Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1BVKce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:32:34 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38728 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1BVKcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CjB8IXF2VhKYWUKEUFM//IvKQdTbOjge6R66P310GX14q/5oA+rOmMKFI4uTiFTJxK
         EGlISnaJgNVtM63tZeagqj6yqjHWJLYle2+gzjyAi+XYfNMWXp4IFOL4zBEpxD1QWANo
         QbtyyeYnCwi/36SRAhGWjDVQ1VBi5nuwzWj+0=
MIME-Version: 1.0
In-Reply-To: <20110222103030.GA22248@elte.hu>
References: <4D5EC05A.60103@kernel.org>
	<4D5EC19A.9030808@kernel.org>
	<20110221104803.GK31267@htj.dyndns.org>
	<4D62A2A4.7060701@kernel.org>
	<20110222102357.GW31267@htj.dyndns.org>
	<20110222103030.GA22248@elte.hu>
Date: Tue, 22 Feb 2011 11:32:32 +0100
X-Google-Sender-Auth: elgfcCjnTLUubxL9rE07nPlNXCc
Message-ID: <AANLkTi=Yt6Q_WWJrUMZvqbLCEE664-v1neFbP27q2JFa@mail.gmail.com>
Subject: Re: [PATCH] x86-64, NUMA: Seperate out numa_alloc_distance() from numa_set_distance()
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Tejun Heo <tj@kernel.org> wrote:
>
>> Alloc code is much bigger the distance setting.  Separate it out into
>> numa_alloc_distance() for readability.
>
> FYI, the From: Yinghai line seems to be missing. If this patch is committed as-is
> then you will be the author.

Oh, don't worry.  It was committed with the proper --author option.  I
just forgot to retain the From header while posting the git generated
patch.

Thanks.

-- 
tejun

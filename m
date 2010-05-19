Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0ESHlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:41:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57674 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0ESHlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wrvh5jsMCuf/WN7OSJXEgOMCm5vLmNKACT2q9gyvXHB94A/dmrbtsNwx9Gerxy925u
         uK971hyLblWsASJqUEk5dp754zAmWdwB1uBOpLpaIopQUCVIF/zF7CKqMnYRh1BLntRA
         WN2jFWAgV9NgeviB+J6RykzV95Zsw6anZtfE4=
MIME-Version: 1.0
In-Reply-To: <20100519073509.GF9618@elte.hu>
References: <20100518211916.407689068@openvz.org>
	 <20100518212439.542226770@openvz.org> <20100519073509.GF9618@elte.hu>
Date: Wed, 19 May 2010 11:41:04 +0400
X-Google-Sender-Auth: ERZK3N5sooShv-9EDXS28fD2Mng
Message-ID: <AANLkTikgZKLarGNvR39Ht4Di7ocfWAEPCOASgwIHc88S@mail.gmail.com>
Subject: Re: [patch 4/4] x86,perf: P4 PMU -- prepare header for user-space 
	inclusion
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 19, 2010, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
>> The header need to be exported to be able to use P4 PMU
>> in user space applications (for RAW events mostly).
>
> Would be much better to create a pure, separate header
> file with hardware event format details, without all these
> ugly #ifdefs mixed into a single file.
>
> Thanks,
>
>         Ingo

seems reasonable, yes! Drop this patch for a while. Thanks!

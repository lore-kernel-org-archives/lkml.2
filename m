Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1BBESY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 23:18:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55396 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1BBESW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 23:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vCZ8a7Sy5EqySp6IsrUC7Eo07Y5mS7pXq65AXDHI/gQNZ2ZGClCNOtEiGVBik+pJzt
         zVQAETyj44ErP/I+MxTxbsmht+HipNwC3+g1R47vmhNQouSsFhTNTmEkFcN5b9SssIRc
         p6s6AcFp/5xgw0R36CdVnoC4azbn40O2Ctc+E=
MIME-Version: 1.0
In-Reply-To: <20110202023610.3799.qmail@science.horizon.com>
References: <4D484853.9020409@gmail.com>
	<20110202023610.3799.qmail@science.horizon.com>
Date: Wed, 2 Feb 2011 07:18:20 +0300
Message-ID: <AANLkTi=X8vCuVOCMBJiCOB-8GZRF4-5RVx59QchecLz4@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/11, George Spelvin <linux@horizon.com> wrote:
>>  But if you have a will or would like to help debug the problem -- mind to
>> try the patch below? Note the patch is ugly at moment and must *not* be
>> running on non-P4 system (and I only compile-tested it so no guarantees
>> at all, and I've CC'ed a couple of people as well)
>
> Promising...  After 32 minute of uptime, no NMI complaints so far.
>
> I'll let it run overnight and see what happens.
>

Great, thanks. Though the patch didn't help for Don, ie there is still
an issue which needs to be resolved as well.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0HJG1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:27:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54727 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab0HJG1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Rkkdz1cNk4ImqNcTaxhcjY9kdD4s7JUgWfTPsT8WTsoVuVH6saMC7UwYdyCNagiTCN
         0FTzm8HiF3Y+uxrSP3Yrf/sKRS+u9uvR96Tvcxg2EopEes2Bpyx//prAA29I1gyl01jz
         rdlVwmlHwA6ezDvVW1+WxH02Upj+szedmhsXw=
MIME-Version: 1.0
In-Reply-To: <4C470E69.7020900@kernel.org>
References: <861vaxjij8.fsf@peer.zerties.org> <4C470E69.7020900@kernel.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 10 Aug 2010 02:26:45 -0400
Message-ID: <AANLkTik-DkN7gUwTuquWxA-iziHyonG9ijWb4=K8WUo=@mail.gmail.com>
Subject: Re: Dead Config in mm/percpu.c
To: Tejun Heo <tj@kernel.org>
Cc: Christian Dietrich <stettberger@dokucode.de>,
        David Howells <dhowells@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 11:12, Tejun Heo wrote:
> On 07/21/2010 11:22 AM, Christian Dietrich wrote:
>> We found, that CONFIG_NEED_PER_CPU_KM is a dead symbol, so it isn't defined
>> anywhere. Cause of that the percpu_km.c is never included anywhere. Is
>> this a intended dead symbol, for use in out of tree development, or is
>> this just an error?
>
> Oh, it's new code waiting to be used.  It's for cases where SMP is
> used w/o MMU.  IIRC, it was blackfin.

yep.  unfortunately, we're in the middle of making a release on top of
2.6.34.x.  hopefully we should be able to get a patch out for the
2.6.37 merge window at the latest.
-mike

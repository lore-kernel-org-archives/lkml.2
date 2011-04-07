Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab1DGDSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:18:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39802 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1DGDSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dn89SVBKhZDai3XN9xzqEiKPojf2aZuqtbLRisdhjmufkZQZ5gPklmkNYbWRsF8UYA
         36pzAn+u6BjnaImRSNFjlwG/TlWvcv5y9y7kMZvLXNluADd+PNbWcVEXatM3Y2fT/H4I
         zCkl924TQCqd9QJqKhPff438qEI4DzCkvKYUE=
MIME-Version: 1.0
In-Reply-To: <20110407001658.GW12642@redhat.com>
References: <20110406223036.GA15721@digium.com>
	<20110407001658.GW12642@redhat.com>
Date: Thu, 7 Apr 2011 07:18:50 +0400
X-Google-Sender-Auth: rHpOS7MycNV_guMh2WCXhipTBwc
Message-ID: <BANLkTi=W45VbeBNThBqKv2Wbo+8sWxXjuA@mail.gmail.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Shaun Ruffell <sruffell@digium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 7, 2011, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Apr 06, 2011 at 05:30:36PM -0500, Shaun Ruffell wrote:
>> Hello Don,
>>
>> I was able to bisect it down to commit 242214f9c1eeaae40, but I'm not
>> certain where to go from here.  Is this something that is already known
>> or is there more information I should try to collect?
>
> Nope, this is an ongoing issue.  What happened was the perf P4 nmi handler
> was swallowing all the NMIs.  My patch fixed that and exposed a double NMI
> problem.  We have been chasing it for a couple of months.  I think Cyril
> was finally able to duplicate it (as he wrote the P4 code).  I have
> confidence that he will find a fix for it soon. :-)
>
> Thanks for the report though!
>
> Cheers,
> Don
>

Hi, yeah, i got it too and i hope to fix this issue soon. Will ping as
only get working fix.

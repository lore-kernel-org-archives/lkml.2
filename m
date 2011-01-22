Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1AVV4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 16:56:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50778 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1AVV4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 16:56:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dko9+T2CRpuQA//OO2CYc7biDfLUfxepQM5gzLKryb4+woDDUJUPE7awERMAi7/gLN
         +LAiBu/nhfIK7LLIFfFOjxSfh8L0yTSWouaQv33WOEIPumJWJWCaLaQkswsIgry73xIA
         P/CI/x0eB6pMbPjiqp4b5bltZRihTlDg08eW4=
MIME-Version: 1.0
In-Reply-To: <20110122205535.GD8666@infradead.org>
References: <20110121094827.41818a55@jbarnes-desktop>
	<20110121095658.1ab623fe@jbarnes-desktop>
	<1295632828.19880.22.camel@m0nster>
	<20110121100441.06a94482@jbarnes-desktop>
	<1295633882.19880.31.camel@m0nster>
	<AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	<1295642995.19880.42.camel@m0nster>
	<AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com>
	<20110121234930.GK3043@thunk.org>
	<1295684398.19231.47.camel@jaguar>
	<20110122205535.GD8666@infradead.org>
Date: Sat, 22 Jan 2011 23:56:14 +0200
X-Google-Sender-Auth: 4wLTtfQnmzwfbwIxUxPN_RurCx0
Message-ID: <AANLkTimKRCAVQSn8cic2OH2+2eOP+RKxWhUkpRw-B3k3@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Daniel Walker <dwalker@codeaurora.org>,
        Dima Zavin <dmitriyz@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph!

On Sat, Jan 22, 2011 at 10:19:58AM +0200, Pekka Enberg wrote:
>> Sure, it would have been nicer for everyone involved if Daniel would
>> have kept the original patches and added new patches to clean it up on
>> top of that to preserve the history.

On Sat, Jan 22, 2011 at 10:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
> No, it would be a complete fucking mess that way.  We tell people to
> submit standalone and well formed patches all the time.  Why would it
> make any difference just because they were also commited to a shitty git
> tree somewhere else?

We also tell people to submit crap into tree all the time - it's
called staging! We also merge full history from time to time like in
the case of btrfs.

Usually even "shitty git trees" have value in the history for people
who're interested why the code is the way it is. But as people who
actually looked at the patches, it doesn't apply here.

                        Pekka

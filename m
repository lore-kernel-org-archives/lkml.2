Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964Ab2C1FMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:12:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2C1FMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:12:51 -0400
Date: Wed, 28 Mar 2012 07:12:43 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
Message-ID: <20120328051243.GA2138@fancy-poultry.org>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
 <201203240553.32526.gene.heskett@gmail.com>
 <57375.1332641134@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57375.1332641134@turing-police.cc.vt.edu>
Organization: private site
X-OpenPGP-KeyID: 0x898F89DE
X-OpenPGP-Fingerprint: 0815 20AD E896 A2B7 488F  4659 4C7B 8951 898F 89DE
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+52 (c26dbc7021f4) (2011-07-01)
X-Provags-ID: V02:K0:aGCP0TkB3MK1zTzYyjdTpAHGZcVsNlpnv9BKgbNdXLw
 As9aF8mjkgl/SGTap+vbC5cPBGKqmjBaOGCcG43Up7/1VyY+TL
 EKK7EVSoGMXHfv2FQ9tEugEiLdKwkydKybcH07oFAH1P+4igUm
 zg3j9P9cd9ZGqCT2XvgAYaK2nRl81xF/TArPmOaLjqZcu0PUOm
 wNw0SNFUNAKEKW5u+GEaXgoG7OAjEH9yqkkHcjXnLMBDl8OcAA
 x/TumLLW0jwpMlxQVMbmVEqgxdBz228vj719RsHXx14TnfcCSI
 vUHZQQhixICQiI8HbldbyG1R6xYKO0uEwWqTNcmn2WiUyH/abd
 fB3zWSi9BuhUO4RXcgCiF8FeSJMDKGa0T6kOy5pg1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.03.2012, Valdis.Kletnieks@vt.edu wrote: 

> I'va always wondered what people are using to measure interactivity. Do we have
> some hard numbers from scheduler traces, or is it a "feels faster"?

I guess it's a "feels faster", because it's the only thing that
counts. Given that there is strong evidence that scheduler A is
"faster, more interactive", whatever... than scheduler B, but a
controlled trial shows a significantly better "feels faster"
experience using scheduler B, I'm quite shure that people would choose
scheduler B over A, and that's quite ok. It does what they expect it
to do, despite evidence which documents the opposite.
 

> And if  it's a subjective thing, how are people avoiding confirmation bias (where you
> decide it feels faster because it's the new kernel and *should* feel faster)?

Confirmation bias is one thing, and it does exist. Surely. So it's up
to the user if it wants evidence, or if it's enough that it feels
faster. I guess that evidence doesn't really matter for the most of
the users as long as they have a positive experience.

> Anybody doing blinded boots, where a random kernel old/new is booted and the
> user grades the performance without knowing which one was actually running?

Hey, we could construct a randomized controlled trial on this :-)
 
> And yes, this can be a real issue - anybody who's been a aysadmin for
> a while will have at least one story of scheduling an upgrade, scratching it
> at the last minute, and then having users complain about how the upgrade
> ruined performance and introduced bugs...

Yep. They who have to do "real work" will rather base it on evidence
than trust their own feelings.

 



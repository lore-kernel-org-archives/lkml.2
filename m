Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2LQI6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:58:13 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:55199 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab2LQI6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:58:11 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH 1/2 v3] Fix memory freeing issues
Date: Mon, 17 Dec 2012 10:58:02 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Cong Ding <dinggnu@gmail.com>
References: <201212101118.08463.vitas@nppfactor.kiev.ua> <201212141133.50312.vitas@nppfactor.kiev.ua> <20121215172540.GB2589@local>
In-Reply-To: <20121215172540.GB2589@local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212171058.03013.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 December 2012 19:25:40 Hans J. Koch wrote:
> On Fri, Dec 14, 2012 at 11:33:50AM +0200, Vitalii Demianets wrote:
> > Hans, why do you want to put in this patch, which is dealing with
> > memory-freeing issues only, completely unrelated functional changes?
>
> Because during review of your patch we happened to find another issue
> a few lines up and down. Why not fix it on the way?
>

Because my heart is not with your solution of irq-related problem. I can't do 
it.

> If you like, make it two patches, one with your memory-freeing issue
> and one "Remove irq tracking" or something like that.

I've done exactly that. The series of two patches. First [patch 1/2] - deals 
exclusively with memory freeing issues and you have no objections to it. 
Second [patch 2/2] which we disagreed upon - deals with irq-related issues.

> That's just 
> three or four lines difference, I'd even accept it if it were only
> one patch.
>
> I don't want to fix one thing now and leave the other one unresolved.
> That would just be a waste of time.

Me too. But we have different vision of the solution to the irq-related issue. 
That's why I won't write the irq-related part.
Also, I don't understand, why do you want two unrelated fixes in one patch? 
When they are separated, they are easier to discuss, study and revert if 
needed.

>
> To be clear, I have no objections regarding your memory freeing ideas.

So, why not to stop here and accept this one patch? I won't write the 
irq-related part anyway, as my heart is with the solution in [patch 2/2] and 
you disagree with it.
So, the irq-related part should be done by someone else. Maybe by you, why 
not?

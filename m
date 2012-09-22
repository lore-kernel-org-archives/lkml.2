Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2IVGND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 02:13:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33529 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2IVGNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 02:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
	<CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
	<20120921192720.GJ7264@google.com>
	<CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
	<CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
	<5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
	<CAK7N6vpLpNM-tfhxpmym_eW+VpF+jnBe+uB=E0mSBk+CtMWp+w@mail.gmail.com>
Date: Fri, 21 Sep 2012 23:12:59 -0700
X-Google-Sender-Auth: lX-d_Dy8WNcC3YxbvZGAbsypJ_g
Message-ID: <CAOS58YPyMJrqLYno1YXUkFop9XTE8r=dCg8AsCK_Fr0yBq5ZWg@mail.gmail.com>
Subject: Re: Work queue questions
From: Tejun Heo <tj@kernel.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>,
        Deepawali Verma <dverma249@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 21, 2012 at 11:05 PM, anish singh
<anish198519851985@gmail.com> wrote:
> Assuming single core,Is my explanation correct about concurrency?

Yes, for bound workqueues, that's correct. Concurrency management
doesn't apply to unbound ones tho. Didn't notice Deepawali's test case
either just didn't take long enough for the scheduler to interleave
the workers or is using a workqueue w/ max_active == 1. I'm afraid
this won't be a particularly productive discussion without the source
code. For more details, please read Documentation/workqueue.txt.

Thanks.

-- 
tejun

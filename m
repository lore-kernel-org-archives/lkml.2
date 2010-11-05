Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab0KEFiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:38:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61686 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0KEFiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J6MYZxBV3Q4hCk/HoXbJsU3XRYZtEF/etBULlOZ4Sq9CYh+RFHh6z6NPw4SQ46sXpj
         zBHuO44LaKZkmQWcmbfXOoLBFvlntdjYPZZL4IoX2M9slIbX1wlP85mVqvaVqqsM4d6F
         xQcuEDxqQ/fz4QEJt0x0RmwMHMP/dF8le8f2M=
MIME-Version: 1.0
In-Reply-To: <20101105052740.GB6698@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com>
	<20101105052740.GB6698@nowhere>
Date: Fri, 5 Nov 2010 06:38:17 +0100
Message-ID: <AANLkTi=RiYTsYfh9sBLBzKeZWJp8HOCP+RnOTQA-MFHL@mail.gmail.com>
Subject: Re: dyntick-hpc and RCU
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/5 Frederic Weisbecker <fweisbec@gmail.com>:
> For now #3 seems to me more viable (with one of the adds I proposed).


Doh, but I forgot it's not preemptable! So #2 looks then more viable.
Unless we can tweak #3 into getting it preemptable.

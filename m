Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2B1PIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:08:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38991 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2B1PIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:08:23 -0500
Message-ID: <1330441686.11248.93.camel@twins>
Subject: Re: lockdep: Warning & NULL ptr deref
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 16:08:06 +0100
In-Reply-To: <CA+1xoqeEa2E7iu+RPiHTYoQO3739UKQm_PjAbxZA0-f+ped+tA@mail.gmail.com>
References: <1330442692.3719.7.camel@lappy>
	 <1330435782.11248.89.camel@twins>
	 <CA+1xoqfMad+s4-E-Nn29m3=bVASEkH38ZNvWg2vY99ZizdAT3Q@mail.gmail.com>
	 <1330438853.11248.90.camel@twins>
	 <CA+1xoqdRES=RwUw8C+8=6neu7t0JZeBAxSaoT2+VA-Z+pvD6oQ@mail.gmail.com>
	 <1330439166.11248.92.camel@twins>
	 <CA+1xoqeEa2E7iu+RPiHTYoQO3739UKQm_PjAbxZA0-f+ped+tA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 16:55 +0200, Sasha Levin wrote:
> > Hmm, cute, does a kernel without lockdep explode too? If its proper
> > memory corruption one would expect that.
> 
> Looks like it only happens when lockdep is there, it also happens in
> the same lockdep line of code all the time. 

OK, that smells.. no good idea then on how this could happen :/

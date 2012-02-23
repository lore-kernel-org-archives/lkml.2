Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2BWR3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:29:05 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:35340 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2BWR3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:29:03 -0500
Message-ID: <4F4676C2.8020807@tu-ilmenau.de>
Date: Thu, 23 Feb 2012 18:26:26 +0100
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120217 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: responsiveness: newer kernels causing lagging and blocking
References: <4F4669B1.4020306@tu-ilmenau.de> <CA+55aFy37+AgjRB0V5f8RMhYPHPo1TK18NnO5s48wyQQP4=bJQ@mail.gmail.com>
In-Reply-To: <CA+55aFy37+AgjRB0V5f8RMhYPHPo1TK18NnO5s48wyQQP4=bJQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm assuming you don't have PREEMPT enabled? Does that hide the problem?
>
>                              Linus
>

It is a PREEMPT kernel with 1000Hz (maximum) NOHZ (tickless).

regards Stephan

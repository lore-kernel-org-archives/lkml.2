Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1BKNlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:41:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37682 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1BKNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mSTJMLXWrcsm8LbxfwiQ0ETesk0HQ5MugkfY1ZDh2U6flUIoLM+8lr76O2UkJXoYvE
         KkRc1Z0barP0Jt4HfvWrsEUlMPwALdFMsNSkl93EICC+pUxJdKQIYc2DwmsdqBnmsdEV
         inJ/ywjcvXFq+wK6k5sY3DucaiSnjifRB5ZH4=
MIME-Version: 1.0
In-Reply-To: <20110210235956.GA3231@elte.hu>
References: <201102091608.59448.rusty@rustcorp.com.au>
	<20110210124416.GE26094@elte.hu>
	<201102110802.17453.rusty@rustcorp.com.au>
	<alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
	<AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
	<20110210235956.GA3231@elte.hu>
Date: Fri, 11 Feb 2011 15:41:44 +0200
Message-ID: <AANLkTikbYZHQoGUOO6NtVORXrUzrqNV3GJVzm0NHeUUy@mail.gmail.com>
Subject: Re: [PULL] cpumask offstack finalization
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 1:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Hey, if that's what it takes to get __deprecated removed i'll bring it up tomorrow!!
> :-)

But first, deprecate it!

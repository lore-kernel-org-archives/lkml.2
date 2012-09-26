Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2IZBCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:02:49 -0400
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:37942 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751148Ab2IZBCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:02:48 -0400
X-Yahoo-Newman-Id: 459394.44109.bm@omp1001.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: D1o3AKYVM1kpcvI4OU4iiOrt7MkGC7qVXTaW3MR6EbFCuZd
 Um848Qci.IPPoH5Qv94DMH2U0ZJntPl46A88oFy2ppzFb_kHip8hmeuAYfcK
 YiNksy5KvN6XfMWn1Dg3zQGuMyy1bBH7.eT9.8VSIZzyySGFBOqBU6kzXL_l
 bVUGyJ6cp9U_ScYPWQ7gl_u997mFWXE0rbLR.3QlHsJXPJwgykT6SrMtJbHS
 nXmXZ9ckZxCLeYjLliUvel_yUSDdGrDwoUmcf.i_oXkAvtp6JnYYmJQZAqCx
 3VsMRMB8bH_DDm7LBHSNCMELhlsBJAol0.rITqCBHKWQT58MZ9lPQeTQICPH
 RpTLjXMWPg_M62PjZZhmZ5YlZx5S_XxUBy1WHfYG9V20LcNstDj9v64WoIny
 DY0SaDp3f9NICZi_32dqo5o38je0p5dcpcSlpKOxaYAdhclLZAoY-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50625436.1020501@att.net>
Date: Tue, 25 Sep 2012 20:02:46 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/25] Generic Red-Black Trees (still WIP)
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com> <1348618742.22822.39.camel@gandalf.local.home>
In-Reply-To: <1348618742.22822.39.camel@gandalf.local.home>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Q&A
>> ===
>> Q: Why did you add BUILD_BUG_ON_NON_CONST() and
>>    BUILD_BUG_ON_NON_CONST42()?
> A: Because BUILD_BUG_ON_NON_CONST42() will crash if it does not result
> in the answer to life, the universe and everything!

By the way, I have a theory before time, God was writing code on some
cosmic computer (beyond our understanding, of course) when he
accidentally tried to divide by zero, resulting in a core dump that we
now know as the universe we live in.  So thus, we are just the excrement
of some celestial computer after it failed to properly execute its code.

Daniel


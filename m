Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640Ab0HGNSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:18:54 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:38111 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757038Ab0HGNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:18:53 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2010 09:18:53 EDT
X-Panda: scanned!
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Filterd-Recvd-Size: 2109
X-User-Agent: K-9 Mail for Android
References: <1268462987-8271-1-git-send-email-rabin@rab.in> <1268462987-8271-8-git-send-email-rabin@rab.in> <20100803164247.GA6133@debian> <1281126198.3352.6.camel@gandalf.stny.rr.com> <AANLkTi=Y7WsfrKy2db9j2v8b6PsEhOF2o953R-CvhmhQ@mail.gmail.com>
In-Reply-To: <AANLkTi=Y7WsfrKy2db9j2v8b6PsEhOF2o953R-CvhmhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
From: Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 07 Aug 2010 08:57:42 -0400
To: Rabin Vincent <rabin@rab.in>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <d8f8776d-ddbd-4429-982e-347be439dc02@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top post. Sent from phone.

Argh! We had this discussion before. I must be getting old.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


"Rabin Vincent" <rabin@rab.in> wrote:

>On Sat, Aug 7, 2010 at 1:53 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> >     "$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>>> >     "$(if $(CONFIG_64BIT),64,32)" \
>>> > -   "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>>> > +   "$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>>> > +   "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>>
>> Hmm, this changes the number of parameters passed to the
>> recordmcount.pl. shouldn't this be part of the change to
>> recordmcount.pl? Otherwise, we can break a bisect.
>
>No, this doesn't change the number of parameters.  KBUILD_CFLAGS
>is included inside the CC argument.
>
>Rabin

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

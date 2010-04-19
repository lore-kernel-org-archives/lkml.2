Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0DSWaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:30:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55188 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0DSWay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K21mk52otzFrxb5fYbl4fYPMTT6L299VbvZOAbGE/hk3QsNML5OMFIHm9Mb66Z7pnl
         94rI0d3qWXBjvc4NG6xqlcBJOXa6mlTnKySNTmUUop7kIfgZcTudxdKw0myKKhId2yy4
         LMtnIHjnfv5rFedODDsl5H4zAby4ZLOZpeeFk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
	 <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
	 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
	 <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
	 <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
	 <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
Date: Mon, 19 Apr 2010 15:30:53 -0700
X-Google-Sender-Auth: e957c9c18a9dfd3c
Message-ID: <q2s40ec3ea41004191530lc743121fm2247dacb4779eca3@mail.gmail.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Chase Douglas <chase.douglas@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2) tracing off can be done via filters on functions and/or events
>   already - so I doubt that the tracing_off_event(level) is necessary
>   at all.

I just found what you were meaning here, since there's no
documentation yet about the traceon/traceoff filter command. This
would do exactly what we want for helping us fix bugs.

I'll write some info about the command in ftrace.txt and send a patch
for review so no one else is left out of the party :).

-- Chase

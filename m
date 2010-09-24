Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab0IXQOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:14:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39677 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab0IXQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Est6Vawtq619VKfN0N5ZG7StdwX1kKaf/uFYHoMLo+fPj8oXK6NvWPuKw8CYCWNTgt
         fGZBqag1dqeBH4QLspiPVu6Issv+hFSwll9fi7sxEnOLzHHBEFLJsO2l0NqiGl304MUQ
         JWbrNidvlOmF2wwF+sdMmkbm9QeUsRLkLz1vU=
MIME-Version: 1.0
Date: Fri, 24 Sep 2010 21:44:43 +0530
Message-ID: <AANLkTikjk-Wqz-dAi4Ozy=PSL7n1-sfrRhrP6GwjavA3@mail.gmail.com>
Subject: latency tracing in mainline or rt
From: Jack Daniel <wanders.thirst@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Jiri Olsa <jolsa@redhat.com>, rostedt@goodmis.org,
        fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can some one tell me the difference between Latency tracing that's
here http://people.redhat.com/mingo/latency-tracing-patches/ and the
tracing supported in the RT kernel here
http://www.kernel.org/pub/linux/kernel/projects/rt/ ? What's the
status of the present latency tracing and its documentation. Does
Ftrace override these with its superior tracing? Any help is highly
appreciated.


Regards,
Jack

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2EIOuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:50:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2EIOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:50:13 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uEXl3daXtzsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=BkvCB09aQ853bLxNmOwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336575010.14207.210.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved text
 (but move it)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Wed, 09 May 2012 10:50:10 -0400
In-Reply-To: <4FAA32B3.3070806@hitachi.com>
References: <20120502192418.024103772@goodmis.org>
	    <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>
	   <1336002032.14207.52.camel@gandalf.stny.rr.com>
	   <4FA7B410.1000804@hitachi.com>
	  <1336394603.14207.117.camel@gandalf.stny.rr.com>
	  <4FA88E1B.1020708@hitachi.com>
	 <1336482295.14207.172.camel@gandalf.stny.rr.com>
	 <4FAA0641.7070409@hitachi.com> <4FAA26DD.4050403@hitachi.com>
	 <4FAA32B3.3070806@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 18:02 +0900, Masami Hiramatsu wrote:

> And I got an concrete idea of kprobes call-optimization which
> uses call instead of jump. That will make ftrace-based optimization
> very easy. :)

I just uploaded my devel branch. If you want to make suggestions, or
even modify and add to what I have, feel free:

   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

rfc/kprobes/ftrace-v2

-- Steve



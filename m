Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0E1BVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:21:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab0E1BVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:21:00 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=GQ3jqF8VmdQA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=NiKR6py9vGVug06BySkA:9 a=71ACFb9r2zmr3cuCf6PJN0XbQAcA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/6] writeback: initial tracing support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
In-Reply-To: <20100528004416.GV12087@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	 <1274784852-30502-2-git-send-email-david@fromorbit.com>
	 <20100527143233.836b2c47.akpm@linux-foundation.org>
	 <20100528004416.GV12087@dastard>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 27 May 2010 21:20:57 -0400
Message-ID: <1275009657.22648.584.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 10:44 +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> >
> > > --- /dev/null
> > > +++ b/include/trace/events/writeback.h
> > > @@ -0,0 +1,171 @@
> > > +#undef TRACE_SYSTEM
> > > +#define TRACE_SYSTEM writeback
> > > +
> > > +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
> > 
> > Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
> > header twice, things explode.  Which negates the purpose of
> > _TRACE_WRITEBACK_H.
> 
> Every other trace event header does this, so if it's wrong then the
> same mistake is in at least 30 files now. I don't know enough about
> the tracing code to know why this is done, and I'm not keen to
> address such a mistake here...

It's all part of the CPP voodoo ritual. You don't want to know why, just
do it, otherwise you may find dancing CPP skulls running around your
bathtub.

If you want to be a CPP Voodoo Witch doctor too, read up on LWN, I
describe some of the magic there.

-- Steve



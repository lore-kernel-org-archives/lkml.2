Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2JJCc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:32:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57813 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab2JJCcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:32:51 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-41-5074de500f0a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>
Cc: "=?utf-8?Q?'Luk=C3=A1=C5=A1_Czerner'?=" <lczerner@redhat.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
References: <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <CAKYAXd_Y0Y0kLyqEm1FVO5TpvrN-WwnF40H3hMe5B7_cTe0nMw@mail.gmail.com>
 <004a01cda542$f398e2c0$dacaa840$%kim@samsung.com>
 <alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com>
 <007c01cda60b$43e7fae0$cbb7f0a0$%kim@samsung.com>
 <alpine.LFD.2.00.1210091250590.11244@dhcp-1-104.brq.redhat.com>
 <008301cda615$ca3b9980$5eb2cc80$%kim@samsung.com>
 <20121009212012.GO23644@dastard>
In-reply-to: <20121009212012.GO23644@dastard>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Wed, 10 Oct 2012 11:32:48 +0900
Message-id: <008c01cda68f$8990e140$9cb2a3c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2mY+PzfwcmQgZvSbKuF0fQEbu0AAAKEmTA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd2AeyUBBq9mK1js2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVM/n6fueCiSsXxiTtYGxgnynYxcnBICJhIrJzv3sXI
	CWSKSVy4t56ti5GLQ0hgEaPEhJ8noJx/jBJH57WzgjSwCWhLbN5vANIgIqAhMW3vEWaQGmaB
	k8wSPdvmM0I0nGeRmLL0KRNIA6eArsTBBREgDcICrhLtf9oZQWwWAVWJ6UcOsIPYvAK2ElN/
	PWWEsAUlfky+xwLSyiygLjFlSi5ImBlo7ZN3F1ghblaXePRXF+IEI4mmly9ZIUpEJPa9eMc4
	gVFoFpJBsxAGzUIyaBaSjgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgoP5mfQOxlUN
	FocYBTgYlXh4KzJKAoRYE8uKK3MPMUpwMCuJ8MqsBArxpiRWVqUW5ccXleakFh9ilOZgURLn
	bfZICRASSE8sSc1OTS1ILYLJMnFwSjUw2ukvlHmt//po3YX7WuEnFusdaD/8w8yOi729V+qk
	d63hxDSf/Rfj9+V78X3/JLcx+OW5axuyfNx5mXb+X3kurHHjhbnyk7jPCE/XzpPN8G+fyuwU
	53X9VvYTtR8l/xbHH97VZ3ws6unXU1JmSsoNaqURUfL8ftsSfbozYlI1XN3XTNj248tMJZbi
	jERDLeai4kQAsCjFEmICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On Behalf Of
> Dave Chinner
> Sent: Wednesday, October 10, 2012 6:20 AM
> To: Jaegeuk Kim
> Cc: 'Lukáš Czerner'; 'Namjae Jeon'; 'Vyacheslav Dubeyko'; 'Marco Stornelli'; 'Jaegeuk Kim'; 'Al Viro';
> tytso@mit.edu; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; chur.lee@samsung.com;
> cm224.lee@samsung.com; jooyoung.hwang@samsung.com; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
> 
> [ Folks, can you trim your responses down to just quote the part you
> are responding to? Having to repeatedly scroll through 500 lines of
> irrelevant text just to find the 5 lines that is being commented on
> is exceedingly painful.  ]

Ok, I'll keep in mind.
Thanks.

> 
> On Tue, Oct 09, 2012 at 09:01:18PM +0900, Jaegeuk Kim wrote:
> > > From: Lukáš Czerner [mailto:lczerner@redhat.com]
> > > > > I am sorry but this reply makes me smile. How can you design a fs
> > > > > relying on time attack heuristics to figure out what the proper
> > > > > layout should be ? Or even endorse such heuristics to be used in
> > > > > mkfs ? What we should be focusing on is to push vendors to actually
> > > > > give us such information so we can properly propagate that
> > > > > throughout the kernel - that's something everyone will benefit from.
> > > > > After that the optimization can be done in every file system.
> > > > >
> > > >
> > > > Frankly speaking, I agree that it would be the right direction eventually.
> > > > But, as you know, it's very difficult for all flash vendors to promote and standardize that.
> > > > Because each vendors have different strategies to open their internal information and also try
> > > > to protect their secrets whatever they are.
> > > >
> > > > IMO, we don't need to wait them now.
> > > > Instead, from the start, I suggest f2fs that uses those information to the file system design.
> > > > In addition, I suggest using heuristics right now as best efforts.
> 
> And in response, other people are "suggesting" that this is the
> wrong approach.

Ok, it makes sense.
I agree that the Linaro survey has been well proceeded, and no more heuristic is needed.

> 
> > > > Maybe in future, if vendors give something, f2fs would be more feasible.
> > > > In the mean time, I strongly hope to validate and stabilize f2fs with community.
> > >
> > > Do not get me wrong, I do not think it is worth to wait for vendors
> > > to come to their senses, but it is worth constantly reminding that
> > > we *need* this kind of information and those heuristics are not
> > > feasible in the long run anyway.
> > >
> > > I believe that this conversation happened several times already, but
> > > what about having independent public database of all the internal
> > > information about hw from different vendors where users can add
> > > information gathered by the time attack heuristic so other does not
> > > have to run this again and again. I am not sure if Linaro or someone
> > > else have something like that, someone can maybe post a link to that.
> 
> Linaro already have one, which is another reason why using
> heuristics is the wrong approach:
> 
> https://wiki.linaro.org/WorkingGroups/Kernel/Projects/FlashCardSurvey?action=show&redirect=WorkingGrou
> ps%2FKernelConsolidation%2FProjects%2FFlashCardSurvey
> 
> > As I mentioned, I agree to push vendors to open those information all the time.
> > And, I absolutely didn't mean that it is worth to wait vendors.
> > I meant, until opening those information by vendors, something like
> > proposing f2fs or gathering heuristics are also needed simultaneously.
> >
> > Anyway, it's very interesting to build a database gathering products' information.
> > May I access the database?
> 
> It's public information.
> 
> If you want to support different types of flash, then either add
> your timing attack derived information on specific hardware to the
> above table, or force vendors to update it themselves if they want
> their flash memory supported by this filesystem.

Sound good.
If I also get something, I'll try.
Thank you.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


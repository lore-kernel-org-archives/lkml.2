Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab2JZIbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:31:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57349 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab2JZIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:31:48 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-2c-508a4a72f871
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <1351077945.2097.9.camel@slavad-ubuntu>
 <00e601cdb32a$59fbe090$0df3a1b0$%kim@samsung.com>
 <201210260818.18155.arnd@arndb.de>
In-reply-to: <201210260818.18155.arnd@arndb.de>
Subject: RE: [PATCH 02/16 v2] f2fs: add on-disk layout
Date: Fri, 26 Oct 2012 17:31:46 +0900
Message-id: <011901cdb354$55cfa9f0$016efdd0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2zUnjcI2LV+TZCTTeUYDDqe+bG5wAAVaFA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY90ir64Ag2vLlCz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL2XpnEUtDKXXF51Rq2BsYTHF2MnBwSAiYS+/7/ZIOw
	xSQu3FsPZHNxCAksY5SY/H8jM0zR/Yt7mCASixglTm14yQLh/GOU6Ji7lrGLkYODTUBbYvN+
	A5AGEQFlieMv77CA2MwCfxglLm3QBLGFBA4wSny/aw5icwroS/xbcRpsgbCAmUTf24fsIDaL
	gKpEa9cRJhCbV8BW4tu2uywQtqDEj8n3oGaqS0yat4gZwpaX2LzmLTPICRJA8Ud/dSFOMJJY
	Onc1G0SJuMSkBzDjBSS+TT7EAlEuK7HpADPIJxICq9glpk+cAQ0ISYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MUJiTGoH48oGi0OMAhyMSjy8
	ESmdAUKsiWXFlbmHGCU4mJVEeHdPBQrxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhyPjD+80ri
	DY2NTcxMTE3MLU3NTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgrP0d456+jqsp6v1k
	0eXT0w6snLr96Nf2zsMXjd9en7Y5wP/oJanqb6dd5SXi7UzuK6izRAf9vjOTc4ahuir7kQ2z
	uuV2HT+Q1eafUsdS7mITEPxn368nG1q9DmhNrDMXW30xvV42uzv+1iunNGv15WVP/xmsvbqx
	zvueWl15i7TMr8hCu/Y6JZbijERDLeai4kQAD8QzCN4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd0ir64Ag7N35Sz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz9l6ZxFLQyl1x
	edUatgbGExxdjJwcEgImEvcv7mGCsMUkLtxbz9bFyMUhJLCIUeLUhpcsEM4/RomOuWsZuxg5
	ONgEtCU27zcAaRARUJY4/vIOC4jNLPCHUeLSBk0QW0jgAKPE97vmIDangL7EvxWnmUFsYQEz
	ib63D9lBbBYBVYnWriNgi3kFbCW+bbvLAmELSvyYfA9qprrEpHmLmCFseYnNa94yg5wgARR/
	9FcX4gQjiaVzV7NBlIhLTHrwkH0Co9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIjuBnUjsYVzZYHGIU4GBU4uGNSOkMEGJNLCuuzD3EKMHBrCTCu3sqUIg3
	JbGyKrUoP76oNCe1+BCjD9CjE5mlRJPzgcklryTe0NjEzMjSyMzCyMTcHIewkjhvs0dKgJBA
	emJJanZqakFqEcw4Jg5OqQbGcseqC1eN7gkdO6qiozGf68cUmRePp32PnzFVIs7KqlUq+LXS
	hUm59v8cPm1+IJezecpVQZ/4KG4f4Rzrl2zc0ls4Nt363s8U/W7v0aQaBn/fL0lfdWp5uBSt
	r4oIrdll4PH46MnqiQHmhy66tiuxLz6QnLOFY2tRn6HRN+fPh/YJsE7ePdtFiaU4I9FQi7mo
	OBEAyL7jYw0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday 26 October 2012, Jaegeuk Kim wrote:
> 
> > > > +
> > > > +#define F2FS_ROOT_INO(sbi)	(sbi->root_ino_num)
> > > > +#define F2FS_NODE_INO(sbi)	(sbi->node_ino_num)
> > > > +#define F2FS_META_INO(sbi)	(sbi->meta_ino_num)
> > > > +
> > > > +#define GFP_F2FS_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_ZERO)
> > > > +
> > > > +#define MAX_ACTIVE_LOGS	16
> > > > +#define MAX_ACTIVE_NODE_LOGS	8
> > > > +#define MAX_ACTIVE_DATA_LOGS	8
> > >
> > > I think that it makes sense to comment the reasons of such limitations
> > > in MAX_ACTIVE_LOGS, MAX_ACTIVE_NODE_LOGS, MAX_ACTIVE_DATA_LOGS.
> >
> > The maximum number of logs is suggested by arnd before.
> > As I understood, why he suggested such a quite large number is for further
> > optimization of multiple logs without any on-disk layout changes.
> > And, I think it is quite enough.
> 
> I agree. I think Vyacheslav was just asking you to add a comment
> explaining how we got to these numbers, like
> 
> /*
>  * The file format supports up to 16 active logs, which should be
>  * more than enough for future optimizations. The implementation
>  * currently uses no more than 6 logs.
>  * Half the logs are used for nodes, the other half are used for data.
>  */
> 

Right. I added like that.
Thank you for explanation, and it'd better add additional words described by you.

> 
> 	Arnd


---
Jaegeuk Kim
Samsung


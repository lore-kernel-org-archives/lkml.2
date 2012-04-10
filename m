Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab2DJO62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:58:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42717 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2DJO60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120410134522.GC18899@redhat.com>
References: <20120410025327.49693.93562.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<CAJSP0QWA1z6_YQe9hhpG7bCyZQarmU5NXbHsLGTL_zPTk3dOUA@mail.gmail.com>
	<20120410124250.GB29808@redhat.com>
	<CAEH94Li0==w=AUKd5WCPMcqxLh=+N6bKttOwrE8y-xuOyPt_QA@mail.gmail.com>
	<20120410134522.GC18899@redhat.com>
Date: Tue, 10 Apr 2012 22:58:25 +0800
Message-ID: <CAEH94LjvFzwA_=tv9AJc-wAH0j1P=9QQ0TjucuB-KQAG2LBz-Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] adding tracepoints to vhost
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 9:45 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Tue, Apr 10, 2012 at 09:10:48PM +0800, Zhi Yong Wu wrote:
>> >> Perhaps this can replace the vhost log feature?  I'm not sure if
>> >> tracepoints support the right data types but it seems like vhost
>> >> debugging could be done using tracing with less code.
>> >>
>> >> Stefan
>> >
>> > vhost log is not a debugging tool, it logs memory accesses for
>> > migration.
>> Great, it is very appreciated if there's some docs about this
>
> About what? vhost logging? See the comment near the
Yeah, thanks
> definition of VHOST_SET_LOG_BASE in vhost.h
>
>> > _______________________________________________
>> > Virtualization mailing list
>> > Virtualization@lists.linux-foundation.org
>> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>>
>>
>>
>> --
>> Regards,
>>
>> Zhi Yong Wu



-- 
Regards,

Zhi Yong Wu

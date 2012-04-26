Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2DZPg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:36:59 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:58871 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab2DZPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:36:58 -0400
Message-ID: <4F996BA6.9010900@gmail.com>
Date: Thu, 26 Apr 2012 11:37:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Richard Davies <richard@arachsys.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <20120424082019.GA18395@alpha.arachsys.com> <alpine.DEB.2.00.1204260948520.16059@router.home>
In-Reply-To: <alpine.DEB.2.00.1204260948520.16059@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/26/12 10:50 AM), Christoph Lameter wrote:
> On Tue, 24 Apr 2012, Richard Davies wrote:
>
>> I strongly believe that Linux should have a way to turn off swapping unless
>> absolutely necessary. This means that users like us can run with swap
>> present for emergency use, rather than having to disable it because of the
>> side effects.
>
> Agree. And this ooperation mode should be the default behavior given that
> swapping is a very slow and tedious process these days.

Even though current patch is not optimal, I don't disagree this opinion. Can
you please explain your use case? Why don't you use swapoff?

Off topic: I hope linux is going to aim good swap clustered io in future. Especially
when using THP, 4k size io is not really good.


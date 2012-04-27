Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab2D0Nzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 09:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab2D0Nzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 09:55:54 -0400
Message-ID: <4F9AA54E.6050007@redhat.com>
Date: Fri, 27 Apr 2012 09:55:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
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
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <20120424082019.GA18395@alpha.arachsys.com> <alpine.DEB.2.00.1204260948520.16059@router.home>
In-Reply-To: <alpine.DEB.2.00.1204260948520.16059@router.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 10:50 AM, Christoph Lameter wrote:
> On Tue, 24 Apr 2012, Richard Davies wrote:
>
>> I strongly believe that Linux should have a way to turn off swapping unless
>> absolutely necessary. This means that users like us can run with swap
>> present for emergency use, rather than having to disable it because of the
>> side effects.
>
> Agree. And this ooperation mode should be the default behavior given that
> swapping is a very slow and tedious process these days.

I believe that is a bad idea.

With cgroups, the situation is a whole lot less obvious than with
the simple test done in this patch.  Lets see how the 3.4 code
behaves, and if we need any additional changes to reduce swapping
and step up reclaiming of page cache...

-- 
All rights reversed

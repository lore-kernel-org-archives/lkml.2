Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2CVUOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2CVUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:14:11 -0400
Message-ID: <4F6B880C.7000805@redhat.com>
Date: Thu, 22 Mar 2012 16:14:04 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home>            <4F6B7854.1040203@redhat.com> <40300.1332445016@turing-police.cc.vt.edu>
In-Reply-To: <40300.1332445016@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 03:36 PM, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 22 Mar 2012 15:07:00 -0400, Larry Woodman said:
>
>> So to be clear on this, in that case the intention would be move 3 to 4,
>> 4 to 5 and 5 to 6
>> to keep the node ordering the same?
> Would it make more sense to do 5->6, 4->5, 3->4?  If we move stuff
> from 3 to 4 before clearing the old 4 stuff out, it might get crowded?
>
Yes, I didnt try to imply the order in which pages were moved just
the additional moving necessary.


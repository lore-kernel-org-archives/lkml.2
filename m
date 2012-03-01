Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab2CAUgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:36:43 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37841 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2CAUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:36:42 -0500
Message-ID: <4F4FDDCD.4080306@oracle.com>
Date: Thu, 01 Mar 2012 14:36:29 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, Zach Brown <zab@zabbo.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <20120228092926.GA2766@infradead.org> <4F4CEF5A.1020207@zabbo.net> <20120229090803.GA9995@infradead.org> <x49obsgawoo.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49obsgawoo.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F4FDDD2.002E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 02:33 PM, Jeff Moyer wrote:

> I started reviewing, but I think I'll hold off until the next posting.
> Dave, what was the original subject of the thread from Zach back in '09?
> That spinics link isn't working for me anymore, and I'd like to go back
> over my review comments from back then.

Sorry, I accidentally cut the final "l" off the url.

"[RFC] loop: issue aio with pages"

http://www.spinics.net/lists/linux-fsdevel/msg27514.html

Thanks,
Shaggy

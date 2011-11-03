Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1KCDVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:21:30 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35517 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752031Ab1KCDV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:21:27 -0400
Message-ID: <4EB208AB.6030903@tao.ma>
Date: Thu, 03 Nov 2011 11:21:15 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 for 3.2] fs/direct-io.c: Calculate fs_count correctly
 in get_more_blocks.
References: <x49wrblav46.fsf@segfault.boston.devel.redhat.com> <1320200794-2881-1-git-send-email-tm@tao.ma> <20111102073632.GA17580@infradead.org>
In-Reply-To: <20111102073632.GA17580@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 03:36 PM, Christoph Hellwig wrote:
> The patch looks good to me, but given that it neither fixes a bug
> nor a regression I'd probably call it 3.3 material at this point.
OK, so you will take it or I should ask Andrew to take it for now?

Thanks
Tao

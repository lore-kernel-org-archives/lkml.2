Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2JQSAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:00:04 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61184 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab2JQSAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120718173913.GA1298@fieldses.org>
References: <1342476086-21638-1-git-send-email-levinsasha928@gmail.com> <20120718173913.GA1298@fieldses.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 17 Oct 2012 13:59:39 -0400
Message-ID: <CA+1xoqcgWTP8pAY3Ok2R0JM-ZXSkGroEvAFcqP0KaK=dABiTXA@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Prevent kernel stack corruption on long values of flush
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond.Myklebust@netapp.com, davem@davemloft.net, davej@redhat.com,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 1:39 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Tue, Jul 17, 2012 at 12:01:26AM +0200, Sasha Levin wrote:
>> The buffer size in read_flush() is too small for the longest possible values
>> for it. This can lead to a kernel stack corruption:
>
> Thanks!

I've just stumbled on this crash again, and noticed that this patch
never made it in.

Was it just a mixup, or is something still missing?


Thanks,
Sasha

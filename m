Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab2FKVTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:19:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61734 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2FKVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:19:44 -0400
Message-ID: <4FD660EC.2010608@gmail.com>
Date: Mon, 11 Jun 2012 17:19:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1206110856180.31180@router.home> <4FD60127.1000805@jp.fujitsu.com> <alpine.DEB.2.00.1206111336370.4552@chino.kir.corp.google.com> <CAHGf_=rbss0RsoFn7NZ7oFCpCZuEYkPDXaHSW4KHg=Vu8703xA@mail.gmail.com> <alpine.DEB.2.00.1206111602540.9391@router.home>
In-Reply-To: <alpine.DEB.2.00.1206111602540.9391@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/11/12 5:04 PM), Christoph Lameter wrote:
> On Mon, 11 Jun 2012, KOSAKI Motohiro wrote:
>
>> Several years, some one added ZVC stat. therefore, hardcoded line
>
> You are talking to the "some one".... The aim at that point was not the
> beauty of the output but the scaling of the counter operations. There was
> no intention in placing things a certain way. I'd be fine with changes as
> long as we are sure that they do not break anything.

Maybe my english was poor. I didn't talk about your change at last mail. I
talked about some new counters like nr_anon_transparent_hugepages. Hardcoded
linenuber assumption was break multiple times already. therefore, I don't
think line number change causes application breakage.


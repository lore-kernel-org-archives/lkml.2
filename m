Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1LSVPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:15:24 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55937 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1LSVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:15:22 -0500
Message-ID: <4EEFA96C.1080106@gmail.com>
Date: Mon, 19 Dec 2011 16:15:24 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ryota Ozaki <ozaki.ryota@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-mm@kvack.org,
        stable@kernel.org
Subject: Re: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
References: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com> <alpine.DEB.2.00.1112181439500.1364@chino.kir.corp.google.com> <4EEE6DC0.2030007@gmail.com> <alpine.DEB.2.00.1112191252130.28684@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112191252130.28684@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/19/11 3:53 PM), David Rientjes wrote:
> On Sun, 18 Dec 2011, KOSAKI Motohiro wrote:
>
>> Usually, /sys files don't output trailing '¥0'. And, '¥0' is not regular
>> io friendly. So I can imagine some careless programmer think it is garbage. Is
>> there any benefit to show trailing '¥0'?
>>
>
> Nope, it could be removed since the buffer is allocated with
> get_zeroed_page().

ok, thanks.

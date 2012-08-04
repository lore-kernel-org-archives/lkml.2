Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2HDAcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:32:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33952 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2HDAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:32:41 -0400
Message-ID: <501C6DC3.90904@gmail.com>
Date: Sat, 04 Aug 2012 02:33:07 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com> <1344003788-1417-2-git-send-email-levinsasha928@gmail.com> <20120803171515.GH15477@google.com> <501C407D.9080900@gmail.com> <20120803213017.GK15477@google.com> <501C458E.7050000@gmail.com> <20120803214806.GM15477@google.com> <501C4E92.1070801@gmail.com> <20120803222339.GN15477@google.com> <CA+55aFyOst4c3WHbPVbYkSBdBmLJUui5OvoVOh5AuPMnigwnEA@mail.gmail.com> <20120803223634.GO15477@google.com> <CA+55aFwTa_kYgmFwoWa6hwAAM6=2xTgQQf-vEx_gCzpEMnxodQ@mail.gmail.com> <501C66C2.2020706@gmail.com> <CA+55aFziVRRBoTnm2zASGR39W1AB+0=4Sa7qO8e6_hN06ZY8wg@mail.gmail.com>
In-Reply-To: <CA+55aFziVRRBoTnm2zASGR39W1AB+0=4Sa7qO8e6_hN06ZY8wg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 02:05 AM, Linus Torvalds wrote:
> On Fri, Aug 3, 2012 at 5:03 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>> The problem with that code was that it doesn't work with dynamically allocated hashtables, or hashtables that grow/shrink.
> 
> Sure. But once you have that kind of complexity, why would you care
> about the trivial cases?

Because there are far more trivial cases than complex ones - I've counted 50+ of these "trivial" cases.

None of them need the complexity we're trying to deal with at the moment.

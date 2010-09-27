Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab0I0HXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab0I0HXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:23:45 -0400
Message-ID: <4CA0465F.6080508@redhat.com>
Date: Mon, 27 Sep 2010 15:23:11 +0800
From: Eugene Teo <eugene@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Jiri Olsa <jolsa@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [RFC PATCH] proc: making "limits" world readable
References: <1285060255-15784-1-git-send-email-jolsa@redhat.com> <20100923145642.49f17b20.akpm@linux-foundation.org> <20100924105547.GA1818@jolsa.brq.redhat.com> <20100924162007.GD30252@hmsreliant.think-freely.org>
In-Reply-To: <20100924162007.GD30252@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2010 12:20 AM, Neil Horman wrote:
> On Fri, Sep 24, 2010 at 12:55:47PM +0200, Jiri Olsa wrote:
>> On Thu, Sep 23, 2010 at 02:56:42PM -0700, Andrew Morton wrote:
>>> On Tue, 21 Sep 2010 11:10:55 +0200
>>> Jiri Olsa<jolsa@redhat.com>  wrote:
>>>
>>>> hi,
>>>>
>>>> I'd like to have the /proc/<pid>/limits file world readable,
>>>
>>> Why?
>>>
>>
>> having this will ease the task of system management for large install
>> bases and where root privileges might be restricted
>>
>> jirka
>>
> I don't see a problem with making this file world readable.  Doing so would be
> in keeping with most of the other stats bearing files in /proc/<pid>.  The only
> reason I didn't make it world readable was because the getrlimit sematics
> previously kept limit information private to the process, and I didn't want to
> deviate from that.  But as long as we're not making it world writeable I think
> we're ok.
>
> Acked-by: Neil Horman<nhorman@tuxdriver.com>

I agree with Neil. I can't see how this can be a problem as long as it 
is just world-readable.

Eugene
-- 
main(i) { putchar(182623909 >> (i-1) * 5&31|!!(i<7)<<6) && main(++i); }

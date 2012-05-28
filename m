Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2E1JZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:25:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2E1JZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:25:32 -0400
Message-ID: <4FC34489.5000707@redhat.com>
Date: Mon, 28 May 2012 12:25:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>, mtosatti@redhat.com,
        Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kvm: KVM internal error. Suberror: 1
References: <1336324765.3638.4.camel@lappy> <4FA787D5.6040508@redhat.com> <CA+1xoqf7W1WsEvMHCEUZjBHJVUCaefnGo9qxu0pttCtoUURseg@mail.gmail.com> <CA+1xoqeha3EcYCy=sjER-9B0wn8wTdT-cUTwnvs7uN38uYFpmQ@mail.gmail.com> <20120527062129.GK9769@redhat.com> <CA+1xoqeT0rSymQDT=k9YhUNnbvVwnkY0SKYbMFHWft40uLfndg@mail.gmail.com>
In-Reply-To: <CA+1xoqeT0rSymQDT=k9YhUNnbvVwnkY0SKYbMFHWft40uLfndg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2012 11:23 AM, Sasha Levin wrote:
> On Sun, May 27, 2012 at 8:21 AM, Gleb Natapov <gleb@redhat.com> wrote:
>> On Sun, May 27, 2012 at 02:55:39AM +0200, Sasha Levin wrote:
>>> On Fri, May 11, 2012 at 1:40 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>> > I wasn't able to reproduce this issue so far.
>>>
>>> So I've managed to hit this again, this time with a 3.4 host kernel:
>>>
>> Do you have this instance of QEMU running?
> 
> Nope, qemu pretty much hangs at that point, so I've killed it.
> 
> Should I wait with that next time?

Use -monitor stdio if you don't already.

-- 
error compiling committee.c: too many arguments to function

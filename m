Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2E0IXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 04:23:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49929 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2E0IXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 04:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120527062129.GK9769@redhat.com>
References: <1336324765.3638.4.camel@lappy> <4FA787D5.6040508@redhat.com>
 <CA+1xoqf7W1WsEvMHCEUZjBHJVUCaefnGo9qxu0pttCtoUURseg@mail.gmail.com>
 <CA+1xoqeha3EcYCy=sjER-9B0wn8wTdT-cUTwnvs7uN38uYFpmQ@mail.gmail.com> <20120527062129.GK9769@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 27 May 2012 10:23:23 +0200
Message-ID: <CA+1xoqeT0rSymQDT=k9YhUNnbvVwnkY0SKYbMFHWft40uLfndg@mail.gmail.com>
Subject: Re: kvm: KVM internal error. Suberror: 1
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com,
        Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 8:21 AM, Gleb Natapov <gleb@redhat.com> wrote:
> On Sun, May 27, 2012 at 02:55:39AM +0200, Sasha Levin wrote:
>> On Fri, May 11, 2012 at 1:40 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> > I wasn't able to reproduce this issue so far.
>>
>> So I've managed to hit this again, this time with a 3.4 host kernel:
>>
> Do you have this instance of QEMU running?

Nope, qemu pretty much hangs at that point, so I've killed it.

Should I wait with that next time?

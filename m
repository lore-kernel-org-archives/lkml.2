Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1LWARP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1LWARM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:17:12 -0500
Message-ID: <4EF3C87D.5030608@zytor.com>
Date: Thu, 22 Dec 2011 16:17:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
In-Reply-To: <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2011 02:25 PM, Linus Torvalds wrote:
> I don't *think* anybody does something as crazy as giving actual block
> device ownership to people, but I don't know...

It's quite common and often very necessary to do, to allow a user to
manipulate a device that is not intended to be mounted.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0C0CHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:07:33 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:58011 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0C0CHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hyTpAssDJ13odrZtvwUZmjdVBdGV9YMnY4QAuj/8aQhkr8T6m6byjpe1bvEvyoCK1x
         +9vkEJsJ9LJhE7IxLPodT5Rqxu9NSMUdJgQxT49+EKk3zsC8wNmEuuiROwW9IqRLkPZc
         D5ldiZImoi1yAIOdAJf9ndnMlKVAWwBd/KOXE=
MIME-Version: 1.0
In-Reply-To: <84621a61003261555q2c78f6a8o5b438113bed6bd2@mail.gmail.com>
References: <20100326223530.GA11817@xpc.home> <1269643470.2256.17.camel@edumazet-laptop> 
	<84621a61003261555q2c78f6a8o5b438113bed6bd2@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 26 Mar 2010 19:07:11 -0700
Message-ID: <a36005b51003261907x7ebe057bt2d541f63f20f632b@mail.gmail.com>
Subject: Re: [PATCH] Add MSG_WAITFORONE flag to recvmmsg
To: Brandon Black <blblack@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 15:55, Brandon Black <blblack@gmail.com> wrote:
> Ok.  I've never been through this process before.  Do I resubmit a new
> subject/thread with the changed patch and [PATCH v2] at this point?

The patch is small enough for this to be OK.

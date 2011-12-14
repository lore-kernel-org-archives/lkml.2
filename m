Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1LNOC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:02:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab1LNOCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:02:53 -0500
Message-ID: <4EE8AC88.1040205@redhat.com>
Date: Wed, 14 Dec 2011 16:02:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Nate Custer <nate@cpanel.net>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: kvm deadlock
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com> <20111214140027.GF18317@amt.cnet>
In-Reply-To: <20111214140027.GF18317@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 04:00 PM, Marcelo Tosatti wrote:
> The other traces have apparently bogus NMI interrupts, but it might be a
> software bug, OK.

These are from sysrq-blah, no?  I'm looking at them now.



-- 
error compiling committee.c: too many arguments to function


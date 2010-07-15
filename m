Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab0GOT2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:28:22 -0400
Received: from claw.goop.org ([74.207.240.146]:42631 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934378Ab0GOT2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:28:21 -0400
Message-ID: <4C3F6153.6020005@goop.org>
Date: Thu, 15 Jul 2010 12:28:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
References: <4C3E363B.7060804@goop.org> <4C3E5637.4010300@redhat.com> <4C3E5C8C.8000800@goop.org> <b6d9e574-daf5-4aaa-b76e-4a7e66d0fa97@email.android.com> <4C3F1C84.8080503@goop.org> <4C3F5972.2030600@zytor.com>
In-Reply-To: <4C3F5972.2030600@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 11:54 AM, H. Peter Anvin wrote:
> No, we haven't.  You're misunderstanding what a "memory" clobber does.
> A clobber affects the output side only, but doesn't inherently provide
> ordering on the input side.  Apparently this is implicit in "asm
> volatile", which is a very important property.

OK. It would be nice to get that confirmed.

    J


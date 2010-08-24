Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0HXVdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:33:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab0HXVdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:33:19 -0400
MIME-Version: 1.0
In-Reply-To: <1282291669-25709-13-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
	<1282291669-25709-13-git-send-email-zamsden@redhat.com>
Date: Tue, 24 Aug 2010 14:33:14 -0700
Message-ID: <AANLkTi=_j48vJmmpCTZF1go2-NH7rXnT74AmTHWt-_VS@mail.gmail.com>
Subject: Re: [KVM timekeeping 12/35] Robust TSC compensation
From: Daniel Verkamp <daniel@drv.nu>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 1:07 AM, Zachary Amsden <zamsden@redhat.com> wrote:
[...]
> +        * or make a best guest using elapsed value.

Perhaps s/guest/guess/ while the line is changing anyway.

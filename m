Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1ACVhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:37:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45948 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab1ACVhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:37:07 -0500
Message-ID: <4D224169.3050905@zytor.com>
Date: Mon, 03 Jan 2011 13:36:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sedat Dilek <sedat.dilek@googlemail.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, riel@redhat.com,
        mtosatti@redhat.com, gleb@redhat.com, avi@redhat.com,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
In-Reply-To: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2011 03:01 PM, Sedat Dilek wrote:
>  arch/x86/kernel/kvm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Avi, I'm presuming this is yours?

	-hpa

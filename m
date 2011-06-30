Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1F3VTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:19:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40933 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1F3VTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:19:36 -0400
Message-ID: <4E0CE855.1000402@zytor.com>
Date: Thu, 30 Jun 2011 14:19:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        penberg@kernel.org, tglx@linutronix.de, asias.hejun@gmail.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tools/kvm] kvm tools: Make default host ip address to 192.168.33.1
References: <tip-6ba4b23023bfc6f7659e5f575845d62c5cc5a1ae@git.kernel.org>
In-Reply-To: <tip-6ba4b23023bfc6f7659e5f575845d62c5cc5a1ae@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 02:09 PM, tip-bot for Asias He wrote:
>  #define DEFAULT_GUEST_MAC	"00:15:15:15:15:15"

If you're going to hard-code a MAC at least please have the decency to
set bit 1 in the first octet.

	-hpa


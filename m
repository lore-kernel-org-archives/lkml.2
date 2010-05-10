Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab0EJXLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:11:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590Ab0EJXKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:10:53 -0400
Subject: Re: Keep index within boundaries in kvmppc_44x_emul_tlbwe()
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <AANLkTil_SWX1iPKRmD_YQgtgQcCzV27MEQwP6tPPQRXL@mail.gmail.com>
Date: Tue, 11 May 2010 01:10:49 +0200
Cc: Roel Kluin <roel.kluin@gmail.com>, kvm-ppc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <EF12637D-6AA6-4F95-B806-BADACFB16B00@suse.de>
References: <4BE6D437.9000200@gmail.com> <AANLkTil_SWX1iPKRmD_YQgtgQcCzV27MEQwP6tPPQRXL@mail.gmail.com>
To: Hollis Blanchard <hollis@penguinppc.org>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.05.2010, at 00:58, Hollis Blanchard wrote:

> On Sun, May 9, 2010 at 8:26 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
>> An index of KVM44x_GUEST_TLB_SIZE is already one too large.
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Acked-by: Hollis Blanchard <hollis@penguinppc.org>

Acked-by: Alexander Graf <agraf@suse.de>


Alex


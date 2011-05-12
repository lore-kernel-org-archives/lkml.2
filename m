Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1ELSPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:15:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932349Ab1ELSO7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:14:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110512180638.GA5012@ram-laptop>
References: <4DC250A6.9040802@kernel.org> <20110506081243.GF16782@ram-laptop>
 <4DC4586C.6020308@kernel.org> <20110507015240.GN16782@ram-laptop>
 <4DC4B059.3030502@kernel.org> <4DC64C58.70203@kernel.org> <20110509142014.617e3100@jbarnes-desktop>
 <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com> <4DC9E415.5010402@kernel.org>
 <20110512180638.GA5012@ram-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 11:14:07 -0700
Message-ID: <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
To: Ram Pai <linuxram@us.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:06 AM, Ram Pai <linuxram@us.ibm.com> wrote:
>
> I like this approach than the earlier approach because it
> closes the subtle bug _introduced_ by my earlier patch,
>        commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
>
> However i think the implementation can be made cleaner. Comments below..

Ack on all of that. Do we have confirmation that the patch works, though?

                 Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1EIWhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:37:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab1EIWhC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110509142014.617e3100@jbarnes-desktop>
References: <4DC250A6.9040802@kernel.org> <20110506081243.GF16782@ram-laptop>
 <4DC4586C.6020308@kernel.org> <20110507015240.GN16782@ram-laptop>
 <4DC4B059.3030502@kernel.org> <4DC64C58.70203@kernel.org> <20110509142014.617e3100@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 May 2011 15:36:10 -0700
Message-ID: <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ram Pai <linuxram@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 2:20 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Linus?  Bjorn?  Ram?

I dunno. The patch really makes me go "that looks *broken*". I really
dislike it. But maybe the crappiness of the patch comes from the
horror that is the current code.

               Linus

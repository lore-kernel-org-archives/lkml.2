Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2CITFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:05:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50812 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2CITFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo59nU_GVA4i_x4m_jaxD1Aq6k62NXZVE3Xev0QP9ytnUg@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-7-git-send-email-yinghai@kernel.org>
	<CAErSpo4ynKbMWUUo2QdVr6fbRYoexSXpQrgYbE+AXhXgg5yzvA@mail.gmail.com>
	<CAE9FiQWjsfduRrFqgxq-_ceg8kC-Bi-g4nGUYp0t1sZk3gM95g@mail.gmail.com>
	<CAErSpo59nU_GVA4i_x4m_jaxD1Aq6k62NXZVE3Xev0QP9ytnUg@mail.gmail.com>
Date: Fri, 9 Mar 2012 11:05:35 -0800
X-Google-Sender-Auth: yuNX0BVKkYaLGOLrOCHN2OS4De4
Message-ID: <CAE9FiQVTOM=GUDusgmV31mbyBOuNKsxnm+v1cx-Liq=CNUWLfQ@mail.gmail.com>
Subject: Re: [PATCH 06/23] PCI: rescan with bus or bridge using callback
 method too
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 9:22 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Why did you just repeat my proposal, changing "err" to "ret"?  I
> missed the point you're trying to make.  The name "err" gives an
> important clue that device_schedule_callback() returns 0 or errno.
> That's essential to understanding the code.
>
> Your original patch has one "return."  Mine proposal has three.  All
> that means is that the reader of your patch has to manage more stuff
> in her head to understand the code.  That's not a benefit!

ok, can we have separated patch to fix them all?

Yinghai

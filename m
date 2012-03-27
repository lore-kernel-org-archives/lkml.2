Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2C0U5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 16:57:31 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58219 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180Ab2C0U5a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <4F68D14B.60409@gmx.net>
References: <4F68D14B.60409@gmx.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Mar 2012 14:57:08 -0600
Message-ID: <CAErSpo7Xt2Pz5EqDO_NJGyRkPMrY21vzWJBK1ORwu=j+9t55Gg@mail.gmail.com>
Subject: Re: [PATCH 0/3] PNP: Allow PNP resources to be disabled (interface)
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: abelay@mit.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:49 PM, Witold Szczeponik
<Witold.Szczeponik@gmx.net> wrote:
> Hello everybody,
>
> this simple patch series continues the work begun in commit
> 18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates
> with empty/disabled resources are handled.
>
> The aim of this patch series is to allow to set resources as "disabled" using
> the "/sys/bus/pnp/devices/*/resources" interface.  Such "disabled" resources
> are needed by some vintage IBM ThinkPads like the 600E where some resources
> need to have their IRQs disabled in order to support all the devices the 600E
> has.

If I understand this correctly, even with this patches, you still have
to manually muck around with "/sys/bus/pnp/devices/*/resources" to get
these ThinkPads to work?  If that's the case, there must be more PNP
work we could do to make them Just Work.  And that's fine; I'm just
trying to understand the current situation better.  Is there a
bugzilla or other URL with more details?

> To this end, some preparatory work is done, simplifying the code and allowing
> for more flexibility in the definition of these resources.
>
> Here's a brief description of these patches.
>
> [1/3] - Factor out common some code
> [2/3] - Perform the actual setting
> [3/3] - Generalize handling of resource flags
>
> The patches are applied against Linux 3.3.x.
>
> Comments are, as always, welcome.  :-)
>
>
> --- Witold
>

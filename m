Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031369Ab2CPDXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:23:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40068 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031289Ab2CPDXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4nnY27oB3tShgL8DLStHk+ApYFUGWo_=cAEqRJnVK91A@mail.gmail.com>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
	<1331623594-30543-6-git-send-email-yinghai@kernel.org>
	<CAErSpo4nnY27oB3tShgL8DLStHk+ApYFUGWo_=cAEqRJnVK91A@mail.gmail.com>
Date: Thu, 15 Mar 2012 20:23:07 -0700
X-Google-Sender-Auth: hmJZs7a-AOp4gstwKvXm8ASZYV8
Message-ID: <CAE9FiQWr9VfJbjTNECoR-CfD=M9hFvVx1fcvhAEBDi1eV=kLwA@mail.gmail.com>
Subject: Re: [PATCH 05/12] PCI: Add addon_resource support for pci_dev
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 2:30 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> There are some interesting ideas here.  Do they all have to be in the
> same patch?
>
>  - for_each...() helpers
>  - pci_dev_resource_n() stuff
>  - addon resource stuff
>  - addon resource ops

ok, will split them to several ones.

Yinghai
